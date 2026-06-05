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
