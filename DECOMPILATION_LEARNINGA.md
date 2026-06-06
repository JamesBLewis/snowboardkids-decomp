# Decompilation Learnings

## IDO Code Generation: Local vs Extern Data Definitions

The IDO compiler (used at `-O1` for ultra files) generates significantly different code when global variables are defined locally in the same translation unit vs declared as `extern`. Specifically:

- **Local definitions**: The compiler keeps base addresses in registers across multiple 32-bit stores for 64-bit assignments, producing optimal instruction scheduling (e.g., one `lui` for both words of a 64-bit store, productive use of branch delay slots).
- **Extern declarations**: The compiler reloads base addresses between stores, generating extra `lui` instructions and missing delay slot optimization opportunities. This can add 2+ extra instructions per 64-bit store.

This matters when matching `osInitialize` and similar functions that perform 64-bit assignments to global variables like `osClockRate`.

### Workaround

When matching ultra functions that define data globals, keep the data definitions in the C source file (not `extern`). To handle the resulting multiple-definition linker conflicts:

1. Add the symbol addresses to `linker_scripts/libultra_syms.ld` so the linker resolves references to the correct VRAM addresses.
2. Add `--allow-multiple-definition` to `LDFLAGS` in the Makefile.
3. Remove the object's `.data` and `.bss` linker entries from the generated linker script after extraction (the real data comes from the extracted data segments).
4. Add a post-extract step in the Makefile to strip these entries from the generated linker script.

## Symbol Address Placeholders (0x700... vs 0x800...)

Symbols in `symbol_addrs.txt` with `0x700...` addresses are splat placeholders that must be converted to runtime `0x800...` VRAM addresses before the linker can resolve them. Always check for `0x700A` entries when adding ultra source that calls external functions.

## Simple Ultra Functions Often Match Directly

For straightforward ultra functions like `osViSetMode` that don't use _DEBUG code, have no local data, and just call `__osDisableInt`/`__osRestoreInt` around struct field assignments, the upstream ultralib source often matches directly at `-O1` without modification. Always check if the compiled object emits only `.text` (no `.data`/`.rodata`) before looking for data segments to match.

## Handwritten Assembly (.s) Ultra Functions

For libultra functions that are handwritten assembly (e.g., `osWritebackDCacheAll`, `osWritebackDCache`, `bzero`), use the `hasm` segment type in `snowboardkids.yaml` instead of `asm`. The `hasm` type tells splat the code is handwritten and should not be split into individual functions. The YAML comment may be wrong about which function is actually at a given address — verify with the disassembly and `symbol_addrs.txt` before matching (e.g., `writebackdcache.s` contains `osWritebackDCache` while `writebackdcacheall.s` contains `osWritebackDCacheAll`, which are at different ROM addresses).

## Duplicate Symbol Names at Same Address

Some symbols may share the same VRAM address (e.g., `__osSiRawReadIo` and `__osSpRawReadIo` at `0x800AA420`). These are likely different names for the same function. Remove the incorrect/unused name to avoid duplicate symbol errors. Check which name is correct based on the calling context (SI vs SP address space).

## Combining Small Adjacent Ultra Functions

When a YAML `asm` segment contains functions from multiple ultra source files (e.g., `sptaskyield.c` adjacent to `sptaskyielded.c`, `osViSwapBuffer`, etc.), split the segment at the boundary of the target file's functions. Small related functions like `osSpTaskYield` (5 instructions) and `osSpTaskYielded` (from a separate upstream file) can be combined into a single C source file since they share the same headers and are trivially small. The remaining unmatched functions become a separate `asm` segment at the split address.

## Audio Library Functions May Need -O2

While most ultra functions match at `-O1`, audio library functions (under `src/ultra/audio/`) may require `-O2` to match the target assembly. The tighter register allocation and delay slot usage in the target (e.g., saving function arguments in registers rather than spilling to stack) are characteristic of `-O2` optimization. Test both `-O1` and `-O2` when matching audio functions.

## Minimal Headers for Simple Audio Functions

Simple audio library functions like `alSynAddPlayer` that only use public API types (`ALSynth`, `ALPlayer`) and OS primitives (`osSetIntMask`) don't need the internal `synthInternals.h` header. Including `<PR/os.h>` and `<PR/libaudio.h>` is sufficient.

## synthInternals.h for Internal Audio Functions

Audio functions that access internal types (`ALParam`, `PVoice`, `ALFilter`, `__allocParam`) need the `synthInternals.h` internal header. Create a local copy at `include/synthInternals.h` with the needed type definitions (ALParam, ALFilter, PVoice, filter enum values, `__allocParam` declaration). For `PVoice`, use a char padding array for unused fields between `channelKnob` (offset 0xC) and `offset` (offset 0xD8) since the full struct depends on many sub-types (ALLoadFilter, ALResampler, ALEnvMixer).

## ALStartParam Type for Voice Start Functions

The `alSynStartVoice` function uses the internal `ALStartParam` struct (defined in upstream `synthInternals.h`) which has: `next` (ALParam*), `delta` (s32), `type` (s16), `unity` (s16), `wave` (ALWaveTable*). Add this typedef to the project's `include/synthInternals.h` alongside the existing `ALParam` and `PVoice` types. The upstream source matches directly at the default optimization level without modification.

## Matching Assembly-Only Ultra Functions (interrupt.s)

Some ultra source files are pure assembly (`.s`), not C. For these, create a clean handwritten assembly file under `asm/ultra/os/` using the project's `macro.inc` conventions (`glabel`/`endlabel`, COP0 register aliases like `Status` for `$12`), and use the `hasm` segment type in `snowboardkids.yaml`. For `interrupt.s`, the upstream has a `BUILD_VERSION >= VERSION_J` branch — this project uses VERSION_I, so the simpler `#else` path applies (no `__OSGlobalIntMask` interaction). The `macro.inc` file provides COP0 register aliases that can be used directly instead of upstream's `C0_SR`/`SR_IE` macros.

## Verifying Symbol ROM Addresses

When converting `0x700...` splat placeholder symbols to real `0x800...` VRAM addresses, verify the actual ROM address by searching the asm files for the function label. The `0x700...` value uses `0x70000000 + presumed_ROM`, but the presumed ROM may be wrong. For example, `__allocParam` was listed as `0x700A5BA0` (implying ROM 0xA5BA0) but actually lives at ROM 0xA67A0 inside the synthesizer.c segment (VRAM 0x800A5BA0). The asm file `asm/A6690.s` showed `func_800A5BA0` at ROM `A67A0`, confirming the correct address.

## Simple Timer Functions Match Directly from Upstream

For straightforward libultra functions like `osSetTimer` that follow the VERSION_I code path (no `BUILD_VERSION >= VERSION_K` logic), the upstream source matches directly at `-O1` with no modifications needed. The VERSION_I path omits the `__osDisableInt`/`__osRestoreInt` wrapper and the timer list recalculation, using a simpler `__osInsertTimer` + `__osSetTimerIntr` pattern instead. No `.data`, `.rodata`, or `.bss` sections are emitted — only `.text`.

## Verifying BSS Symbol Addresses Against Assembly

When matching functions that reference BSS globals, verify the symbol addresses in `symbol_addrs.txt` against the actual assembly access patterns. The assembly may access a different address than what `symbol_addrs.txt` lists — the disassembler can misidentify which BSS chunk corresponds to which symbol. For example, `__osCurrentTime` was listed at `0x8015E564` (a 0xAFC-byte chunk that was actually a vimgr BSS allocation), but the assembly accessed it at `0x8015F2B0` (adjacent to `__osBaseCounter` at `0x8015F2B8`). Fixing the address in `symbol_addrs.txt` with the correct size annotation (`// size:0x8`) causes the BSS file to regenerate correctly. The `jal` target addresses in assembly use VRAM addresses (`0x800ABB40` not `0x700ABB40`), so splat placeholders must also be converted.

## siacs.c: Zero-Initialized Globals Go to .data with IDO

With IDO at `-O1`, `u32 var = 0` generates a `.data` section entry (not `.bss`). When matching ultra files with zero-initialized globals, the compiled object will emit both `.data` and `.bss` sections. These need to be split out of the existing raw data/BSS segments in `snowboardkids.yaml`. The key steps:

1. Compile the C file and check sections with `mips-linux-gnu-objdump -h` and `mips-linux-gnu-nm -n`.
2. Find the data/BSS symbols in the existing raw asm files (`asm/data/E0C80.data.s`, `asm/data/bss_chunk_c.bss.s`).
3. Split the YAML segments around the emitted ranges (e.g., split `[0xE0C80, data]` into three: before, `.data` for the C file, after).
4. Run `./tools/build-and-verify.sh` — Splat regenerates the asm files based on the new YAML. No manual asm file editing needed.

## siacs.c: Including PRinternal/macros.h for ALIGNED

The `ALIGNED(x)` macro (defined in `PRinternal/macros.h`) expands to `__attribute__((aligned(x)))`, which is redefined as a no-op for non-GCC compilers (IDO) via `#define __attribute__(x)`. Ultra source files using `ALIGNED` must include `PRinternal/macros.h` or IDO will fail with a syntax error at the `ALIGNED` token.
