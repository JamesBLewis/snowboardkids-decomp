# CLAUDE.md

## Repository Overview

This is a matching decompilation project for Snowboard Kids (N64). The goal is to create C code that, when compiled, produces the exact same ROM as the original game.

## Project Structure

- `src` decompiled or partially decompiled C code.
- `include` shared headers and assembly macros.
- `asm/nonmatchings` unmatched assembly functions extracted from the ROM.
- `asm/data` extracted data assembly.
- `assets` binary asset blobs extracted from the ROM.
- `symbol_addrs.txt` project symbol names and addresses.
- `snowboardkids.yaml` Splat configuration for ROM extraction and segment layout.

## Tools

- `./tools/build-and-verify.sh` rebuilds extracted assets/asm, builds the ROM, and verifies the SHA1 checksum.
- `python3 tools/asm-differ/diff.py --no-pager <function name>` compares compiled assembly against the target for a specific function.
- `./tools/claude --bootstrap-only <function name>` creates a per-function matching workspace under `nonmatchings/`.
- `./build.sh <file>.c` inside a generated matching workspace compiles one attempt and compares it to the target function.
- `python3 tools/project_status.py` shows currently non-matching functions when available.
- `python3 tools/data-differ/data_diff.py <symbol>` or `./tools/diff-data <symbol>` compares binary data between the target ROM and compiled output for a specific data symbol.
- `python3 tools/data-differ/data_diff.py --find-first-mismatch` scans data symbols in ROM order and shows the first mismatch. Use this after checksum failures when a data variable may be responsible.

## Decompiling Assembly to C

First create a matching workspace:

```bash
./tools/claude --bootstrap-only <function name>
```

Move to the created `nonmatchings/<function name>` directory. Use the local `build.sh`, `diff.sh`, `objdump.py`, and `map_asm_to_c.py` helpers there. Keep attempts incremental in separate files such as `base_2.c`, `base_3.c`, and so on.

When a function matches, replace the relevant `#pragma GLOBAL_ASM("asm/nonmatchings/...")` in `src/` with real C code, update declarations in `include/` or nearby source files as needed, then run:

```bash
./tools/build-and-verify.sh
```

If checksum verification fails after source changes, inspect all affected functions in the modified file, especially functions using the same structs or globals.
Use `python3 tools/asm-differ/diff.py --no-pager <function name>` to compare each affected function against target assembly from the project root.

## Matching Data

After changing data definitions or data-related struct layout, build first:

```bash
./tools/build-and-verify.sh
```

If the checksum fails and a data mismatch is suspected, locate the first mismatching symbol:

```bash
python3 tools/data-differ/data_diff.py --find-first-mismatch
```

For a known symbol, compare it directly:

```bash
python3 tools/data-differ/data_diff.py <symbol>
./tools/diff-data <symbol>
```

The data differ uses `symbol_addrs.txt` metadata for single-symbol diffs. Symbols need ROM and size annotations such as `rom:0x... size:0x...` for precise comparisons.

## Validation Checklist

- No manual pointer arithmetic for known struct fields.
- Struct and array accesses use `->`, `.`, or indexed access where appropriate.
- Function parameters are typed as specifically as the available context allows.
- Struct sizes and field offsets match assembly access patterns.
- `./tools/build-and-verify.sh` succeeds before the match is considered complete.

## Code Quality Standards

Prefer existing project names, structs, typedefs, and helper macros. Before adding declarations, search `src/` and `include/` for existing definitions to avoid duplicates.

C files should be organized in this order:

- Macro definitions
- Struct definitions
- Global variables
- Function declarations
- Function implementations

When matching code, keep source readable and maintainable. Avoid using assembly includes, hard-coded pointer offsets, or broad `void *` typing as substitutes for understanding the data layout.
