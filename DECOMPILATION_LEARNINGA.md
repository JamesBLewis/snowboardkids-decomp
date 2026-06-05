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
