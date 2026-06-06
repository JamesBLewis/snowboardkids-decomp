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
