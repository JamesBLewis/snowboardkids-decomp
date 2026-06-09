# Decompilation Learnings

Record project-specific compiler behavior, matching patterns, and verified struct or data-layout insights here as they are discovered.

## ultra:sptask.c (0xA5610)

- **Requires -O2, not -O1.** Despite being in `src/ultra/io/`, sptask.c needs `-O2` to match the target register allocation (callee-saved registers s0-s3 for variables surviving across calls). At `-O1`, the compiler uses stack slots instead, producing incorrect code.
- **Requires `-DF3DEX_GBI`** to get `OS_YIELD_DATA_SIZE = 0xC00` (the F3DEX variant). Without it, the default `0x900` produces the wrong `IO_READ` offset (`0x8FC` vs `0xBFC`).
- **`tmp_task` must be at BSS address `0x8015F0D0`.** The static BSS variable needs to be declared `extern` and placed via `symbol_addrs.txt` at its original address, since the linker's BSS layout doesn't match the original build order.
- **Symbol addresses must be real VRAM (0x800...), not splat placeholders (0x700...).** Functions called by matched C source (`osVirtualToPhysical`, `__osSpSetStatus`, `__osSpSetPc`, `__osSpRawStartDma`, `__osSpDeviceBusy`, `__osSpGetStatus`) need their real 0x800... addresses in `symbol_addrs.txt` for the linker to resolve them. The 0x700... addresses only work for asm-to-asm references.
- **Symbol renames propagate through extraction.** Changing names in `symbol_addrs.txt` (e.g., `func_800A5950` → `osVirtualToPhysical`) causes splat to regenerate asm files with the new labels during `make extract`. Manual asm file edits are overwritten.
- **`_bcopy` (not `bcopy`)** is the actual linker symbol for the memory copy function. The header declares `bcopy` but the linked symbol is `_bcopy`.
- **`PRinternal/osint.h`** provides the prototype for `__osSpDeviceBusy` and other internal functions, eliminating "anonymous function" warnings.

## ultra:vimgr.c (0xA51A0)

- **Matches directly from upstream at -O1.** The text range `0xA51A0..0xA5500` is `osCreateViManager` plus the static VI manager main loop, with padding before `osViSetMode`.
- **Owns a small `.data` and large `.bss` block.** `__osViDevMgr` is `.data` at ROM `0xDFF20` / VRAM `0x800DF320` with emitted size `0x20`. The file's `.bss` is `0x8015DEB0..0x8015F0D0`; the following `tmp_task` at `0x8015F0D0` belongs to the existing raw BSS tail, not `vimgr.c`.
- **Verify generated data labels before trusting old symbol names.** A previous `__osViDevMgr` symbol pointed at `0x800DCCBC`, which is nonzero game data. The actual VI manager data is the zeroed `OSDevMgr` accessed by `osCreateViManager` at `0x800DF320`.

## ultra:pimgr.c (0xA4AE0)

- **Defining data locally vs extern changes IDO codegen.** With `OSDevMgr __osPiDevMgr = { 0 }` defined locally, IDO keeps the base register (`at`) alive across multiple struct field stores, producing compact code. With `extern OSDevMgr __osPiDevMgr`, the compiler reloads `at` before each store, adding 4 extra instructions and breaking the match.
- **Struct field offsets can't be exported as separate C symbols.** When matching a data segment that contains a struct, other asm files may reference individual field offsets (e.g., `player_bss_003C` at `__osPiDevMgr + 8`). These can't be defined in C since the struct is a single variable. The field symbol needs to be provided via `linker_scripts/libultra_syms.ld` at its absolute VRAM address.
- **Splitting data segments reveals hidden symbol dependencies.** The raw data object previously defined all label symbols for every offset. Splitting it into a matched `.data` segment means only the C-defined symbols survive. Audit the nm output of the old raw data object for symbols referenced by other asm files.
- **`piint.h` has VERSION_I macro mappings.** `__osPiRawStartDma` maps to `osPiRawStartDma` and `__osEPiRawStartDma` maps to `osEPiRawStartDma` via preprocessor macros in `PRinternal/piint.h` when `BUILD_VERSION < VERSION_J`. The C code uses the double-underscore names but the linker resolves the single-underscore versions.
- **VERSION_I pimgr uses `CartRomHandle`/`LeoDiskHandle`**, not `__Dom1SpeedParam`/`__Dom2SpeedParam`. The `__osCurrentHandle` array is initialized with `extern` handle pointers.
- **No `_FINALROM` / no `ramromMain`.** The ROM build excludes the `#ifndef _FINALROM` debug thread code. The matched function only contains `osCreatePiManager`.

## ultra:synsetvol.c (0xA5FB0)

- **Matches directly from upstream at -O1.** The upstream `synsetvol.c` compiles to matching assembly without modification, using the same include pattern as `synsetfxmix.c` (`<PR/libaudio.h>` + `"synthInternals.h"`).
- **`_timeToSamples` needs VRAM address in symbol_addrs.txt.** The splat placeholder `0x700A5A98` must be corrected to the real VRAM address `0x800A5A98`. The VRAM address can be verified from the diff tool's `jal` target in the original ROM assembly. Added declaration to `include/synthInternals.h`.

## ultra:sinf.c (0xA6170)

- **Requires -O2, not -O1.** The ultralib Makefile uses `-O3` for `src/gu/` files in VERSION_I, but IDO recomp only supports up to `-O2`. Fortunately `-O2` produces identical code to `-O3` for this function. At `-O1`, IDO allocates a 56-byte stack frame and uses different register allocation, producing 48 bytes of extra code that doesn't match.
- **Segment splitting needed when C text is smaller than the original asm range.** The original `[0xA6170, asm]` segment spanned 0xA6170-0xA65D0 (0x460 bytes) covering sinf plus osAiSetFrequency and other functions. The compiled sinf.o text is only 0x1C0 bytes. A new asm segment at 0xA6330 is needed to cover the remaining functions.
- **Rodata segment must be split at the correct ROM offset, not based on symbol VRAM addresses.** The sinf rodata symbols have VRAM 0x800E1B80 but the actual ROM data is at 0xE2780 (within the `[0xE2700, rodata]` YAML segment). Use the linker map file from a baseline build to find the correct rodata segment and offset.
- **`#pragma weak` aliases work with IDO.** The `#pragma weak fsin = __sinf` and `#pragma weak sinf = __sinf` directives produce correct weak symbols that the linker resolves, matching the original symbol layout (sinf and __sinf at the same address).

## ultra:aisetnextbuf.c (0xA65D0)

- **VERSION_I uses `& 0x3FFF == 0x2000` check, not `& 0x1FFF == 0`.** The upstream source checks `(((u32)bufPtr + size) & 0x1fff) == 0` but the VERSION_I ROM checks `(((u32)bufPtr + size) & 0x3fff) == 0x2000`. These are not equivalent — the VERSION_I check is more restrictive, requiring bit 13 to be set.
- **VERSION_I places `__osAiDeviceBusy()` AFTER the hardware bug workaround.** The upstream has the busy check before the workaround for `BUILD_VERSION >= VERSION_J`. VERSION_I has it after, which the code already handles via `#if BUILD_VERSION < VERSION_J`.
- **Static `u8` initialized to 0 emits `.data` (not `.bss`) with IDO.** `static u8 hdwrBugFlag = FALSE;` produces a 16-byte `.data` entry (1 byte + 15 bytes padding), not `.bss`.
- **Data segment split at ROM 0xE0C70.** The `hdwrBugFlag` static lives at VRAM 0x800E0070 (ROM 0xE0C70). The `[0xDFF20, data]` segment was split into three: `[0xDFF20, data]`, `[0xE0C70, .data, ultra/io/aisetnextbuf]`, `[0xE0C80, data]`.

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

Upstream libc assembly can sometimes be reused directly. `../ultralib/src/libc/bzero.s` and `../ultralib/src/libc/bcopy.s` matched as `hasm` under `asm/ultra/libc/` without local macro rewrites.

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

## VI Current Context vs Active Queue Labels

Do not trust `ultra:` YAML comments or generated `D_...` names when a tiny helper returns a global pointer. The range at `0xAC3D0` was annotated as `getactivequeue.c`, but the target loads `0x800E0190`, which is the VI current-context pointer. The correct source is `io/vigetcurrcontext.c` (`__osViGetCurrentContext`), not `os/getactivequeue.c`.

Likewise, `D_800E0190` is the real `__osViCurr` pointer. A later zero-filled block at `0x800E0320` was mislabeled `__osViCurr`; using that stale symbol made `osViGetCurrentFramebuffer` compile to load from `0x800E0320` instead of the target `0x800E0190`. Rename the data label and all asm references to the owning libultra symbol rather than adding aliases.

## Single Commented Segments May Contain Several Libultra Files

The original `0xA5970` segment was commented as `vigetcurrframebuf.c`, but it also contains earlier VI helpers and a following framebuffer helper. Split the range around the exact function: keep `0xA5970..0xA5A60` as asm, match `osViGetCurrentFramebuffer` at `0xA5A60`, then keep `0xA5AA0` as asm until the next helper is identified. If an attempted C segment causes unresolved neighboring symbols, inspect the original range and split it instead of forcing the whole comment range to one source file.

This also applies to incorrect comments. The range at `0xAB010` was commented as `sprawwrite.c`, but the actual functions were `__osSetFpcCsr`, `__osSiRawReadIo`, and `__osSiRawWriteIo`. Split it into `hasm, ultra/os/setfpccsr`, `c, ultra/io/sirawread`, and `c, ultra/io/sirawwrite`; do not keep the misleading comment just because it starts with `ultra:`.

`osAiSetFrequency` at `0xA6330` matches upstream `io/aisetfreq.c`, but the raw segment also includes a following helper at `0xA6490`. Split `aisetfreq.c` at `0xA6490` and leave the helper raw until it is identified.

## Local Header Drift in Audio Heap Sources

Upstream `audio/heapinit.c` includes `<libaudio.h>` and gets `AL_CACHE_ALIGN` from upstream `synthInternals.h`. In this repo, `libaudio.h` lives as `PR/libaudio.h` and the local `include/synthInternals.h` does not define `AL_CACHE_ALIGN`. Defining `AL_CACHE_ALIGN` as `15` locally in `heapinit.c` preserves the upstream codegen and avoids broad header changes.

## Disabled Asserts Without assert.h

Several upstream IO files include `assert.h`, but this repo does not provide that header and builds with `NDEBUG`. For simple VERSION_I IO functions such as `sirawread.c`, `sirawwrite.c`, `pirawread.c`, and `sprawdma.c`, remove the `assert.h` include and the assert statements rather than adding a new local assert header. The resulting code matches because those assertions are disabled in the target build.

## string.c Function Order Can Differ from Upstream

The target `string.c` range at `0xAAB70` uses the upstream function bodies but ROM order is `memcpy`, `strlen`, then `strchr`, not the upstream source order. Port the bodies in ROM order so the object boundaries line up. Also convert `strchr` from the splat placeholder `0x700A9FC4` to the real VRAM address `0x800A9FC4`.

## mtxutil.c Requires ROM Order and Divide-Form L2F

The target `mtxutil.c` range at `0xAAC10` uses `guMtxF2L`, `guMtxIdentF`, `guMtxIdent`, then `guMtxL2F`; upstream orders `guMtxL2F` earlier. Keep the source functions in ROM order. `guMtxL2F` also needs a local `float scale = 0x10000;` and `(float)q / scale`; using the local `FIX32TOF` macro folds into reciprocal multiply at `-O2`, but the target emits `div.s` with `65536.0`.

## crc.c Only Covers the Initial CRC Helpers

The range commented `ultra:crc.c` at `0xA7D50` only contains `__osContAddressCrc` and `__osContDataCrc` through `0xA7ED0`. The following code is controller RAM read/write logic, so split the YAML at `0xA7ED0` and leave the neighbor raw until it is matched to its actual source. The VERSION_I `crc.c` bodies match directly at the repo's IO optimization settings.

## pfsisplug.c Owns __osPfsPifRam and Has a VERSION_I Clear Loop

`pfsisplug.c` defines the `OSPifRam __osPfsPifRam` BSS object at `0x8015F130`; split BSS so `ultra/io/pfsisplug` owns `0x8015F130..0x8015F170`. Annotate `__osPfsPifRam = 0x8015F130; // type:OSPifRam size:0x40` so raw neighboring asm references to `pifstatus` become `__osPfsPifRam + 0x3C` instead of standalone field labels.

The target `__osPfsRequestData` includes a VERSION_I-specific loop that clears all 16 words of `__osPfsPifRam` before setting `pifstatus`. Add the loop as `((u32 *)&__osPfsPifRam)[i] = 0;`; a local `u32 *ram` changes the stack frame. Also declare `u8 *ptr` without initialization and assign `ptr = (u8 *)&__osPfsPifRam;` after `__osPfsPifRam.pifstatus = CONT_CMD_EXE;` so IDO does not hoist the pointer setup above the clear loop.

## cosf.c Mirrors sinf.c Segment Ownership

`gu/cosf.c` matches upstream directly at this repo's GU settings. Like `sinf.c`, it owns both text and rodata: text at `0xAAE80` and the `0x50` coefficient rodata block at `0xE2930`.

## pirawdma.c Segment Also Contains epirawdma.c

The range commented `ultra:pirawdma.c` at `0xAB570` contains two source files: `io/pirawdma.c` for `osPiRawStartDma` at `0xAB570..0xAB650`, then `io/epirawdma.c` for `osEPiRawStartDma` at `0xAB650..0xAB874`, followed by padding to the existing `0xAB880` boundary. Split the YAML at the function label instead of assigning the whole commented range to `pirawdma.c`. Both upstream VERSION_I bodies match directly at the repo's IO `-O1` settings.

## cartrominit.c and leodiskinit.c Omit speed Stores

The VERSION_I upstream `io/cartrominit.c` and `io/leodiskinit.c` are close, but this target does not emit `CartRomHandle.speed = 0` or `LeoDiskHandle.speed = 0`. Leaving those stores in makes the combined text 0x10 bytes too long, which shifts all following text/data/BSS addresses and creates misleading downstream diffs. Use `_bzero` rather than upstream `bzero`, matching this repo's real libc label. The handle BSS objects have `OSPiHandle` size `0x74` and object padding to `0x80`; `__osDiskHandle` sits at `LeoDiskHandle + 0x74` (`0x8015F264`), and the following raw BSS resumes at `0x8015F270`.

## devmgr.c Ends Before the VI Initializer

The `ultra:devmgr.c` range starts at `0xAB880`, but only `__osDevMgrMain` belongs to `io/devmgr.c`; it ends at `0xABD10`. The following `func_800AB110` is a separate VI initialization helper and should remain raw until identified. `devmgr.c` also owns the switch jump table rodata at `0xE2980`. Convert its callable `0x700...` placeholders (`__osResetGlobalIntMask`, `osEPiRawWriteIo`, `osEPiRawReadIo`, `__osSetGlobalIntMask`, `osYieldThread`) to real `0x800...` runtime addresses before linking the source.

## xlitob.c Owns 0x30 Bytes of .data

`libc/xlitob.c` matches upstream for `_Litob`, but its two digit strings are emitted as a 0x30-byte `.data` section at `0xE1080`. Although the string contents account for 0x28 bytes, IDO pads the static data through `0xE10B0`; splitting the following raw data at `0xE10A8` shifts downstream VMAs and breaks the checksum even when the text diff is clean. The helper `lldiv` is the raw function at real runtime address `0x800B0C40`, so convert the old `0x700B0C40` placeholder and rename the raw asm label.

The neighboring `xldtob.c` comment begins at `0xAFEE0`, but that range starts with a static helper before `_Ldtob`. Inspect and split the helper/function boundaries before assigning the range to upstream `xldtob.c`.

`xldtob.c` should be deferred in this repo unless the compile path can handle the needed helper order. With the normal `-O2` asm-processor path, IDO emits `_Ldtob` first and helper code after it; the target has `_Genld` first at `0xAFEE0` and `_Ldtob` at `0xAF850`. Other decomp repos commonly compile this file with `-O3`, but this repo's asm-processor only accepts `-O0`, `-O1`, `-O2`, or `-g`, so a direct C conversion is not currently a clean match.

## pfsgetstatus.c Reuses pfsisplug Helpers

The target `io/pfsgetstatus.c` at `0xA85E0` does not match upstream's one-channel request helper path. It calls `__osPfsRequestData(CONT_CMD_REQUEST_STATUS)` and `__osPfsGetInitData`, both already emitted by `pfsisplug.c`, then indexes the returned `OSContStatus data[MAXCONTROLLERS]` by channel. Matching the target body directly is cleaner than porting upstream `__osPfsRequestOneChannel` / `__osPfsGetOneChannelData`.

## contpfs.c Must Own the Whole Range

The first two `contpfs.c` helpers (`__osSumcalc` and `__osIdCheckSum`) match exactly as C, but splitting after them at `0xA87B4` fails because the C object's `.text` section pads to 16-byte alignment and shifts the following raw asm. Use the full upstream `io/contpfs.c` so the object owns `0xA86F0..0xA9450` and the internal functions pack without section-end padding. Also convert the old `__osGetId = 0x700A8164` placeholder to real VRAM `0x800A8164`; the following raw `pfschecker.c` caller should call `__osGetId`, not `func_800A8164`.

## save.c Matches in ROM Order

The target `audio/save.c` range at `0xAF1D0` is ordered `alSaveParam` first, then `alSavePull` at `0xAF204`; upstream lists `alSavePull` before `alSaveParam`. Port the upstream bodies in ROM order and omit the disabled assert/include noise. Convert `alSaveParam` from its `0x700AE5D0` placeholder to real VRAM `0x800AE5D0`.

`audio/mainbus.c` and `audio/auxbus.c` have the same ROM-order `Param`-then-`Pull` layout, but direct C ports do not currently match: IDO keeps the fifth `Acmd *p` argument in `$s1` for the initial clear commands, while the target loads it into `$t0` before saving callee registers and only later uses `$s1` for `sources`. Leave those ranges raw until the exact source shape or flags are found.

## syncprintf.c Cannot Be Split to Only osSyncPrintf

The `ultra:syncprintf.c` comment on the large `0x464E0` raw segment is misleading: `osSyncPrintf` is only the tiny final-ROM stub at `0x49A4C..0x49A60`, surrounded by unrelated/raw functions. Compiling an empty variadic `osSyncPrintf` with `-O1` emits the exact 0x14-byte instruction sequence, but the C object's `.text` section pads to 0x20. Splitting only `0x49A4C..0x49A60` shifts the following raw function at `0x49A60`; convert the following function too or leave this range raw.
