---
name: match-ultralib-segment
description: Match a given segment to a libultra ROM segment. Use this when converting unidentified asm libultra ranges such as osRecvMesg to matching C source.
---

# Match an Ultralib Segment

## Core Rules

- Match libultra by compiling local source under `src/ultra`; do not patch linker scripts, generated linker scripts, or archive-member references.
- Preserve the upstream libultra subdirectory when possible, for example `../ultralib/src/io/pfsnumfiles.c` becomes `src/ultra/io/pfsnumfiles.c`.
- Keep unidentified neighboring libultra functions as separate `asm` segments until each function is matched as source.
- Source under `src/ultra` should use real libultra names, not `func_...` or `D_...` placeholders.
- Add required callable ROM symbols to `symbol_addrs.txt` with runtime VRAM addresses, not `0x700...` splat placeholder addresses. Never add libultra function aliases to `linker_scripts/libultra_syms.ld`.

## Workflow

1. Inspect the target function before trusting upstream source. Version-specific libultra code can differ from the checked-in upstream copy:

   ```sh
   python3 tools/asm-differ/diff.py --no-pager osPfsNumFiles
   ```

   Watch for local deltas such as extra initialization loops, literal stores, or changed command/status values.

2. Find the upstream source and headers:

   ```sh
   rg -n "osPfsNumFiles" ../ultralib/src ../ultralib/include
   ```

3. Copy or port the upstream file into `src/ultra`, preserving the source subtree. Verify macro values in local headers before using semantic-looking names; for example `CONT_CMD_NOP` may be `0xff`, while the target may want a literal `0`. Treat the upstream as a starting point — the compiled ROM may have been built from a different version of the source. Build early and let the diff guide iterations rather than analyzing the assembly exhaustively beforehand.

   ```text
   ../ultralib/src/os/recvmesg.c -> src/ultra/os/recvmesg.c
   ../ultralib/src/io/pfsnumfiles.c -> src/ultra/io/pfsnumfiles.c
   ```

4. Replace the matching ROM range in `snowboardkids.yaml` with a normal C segment:

   ```yaml
   - [0xA1590, c, ultra/os/recvmesg]
   - [0xA2650, c, ultra/io/pfsnumfiles]
   ```

5. If the new source calls functions or references data already present elsewhere in the ROM, add the real ultralib symbol names to `symbol_addrs.txt`. Avoid using aliases to make the work with unlabeled symbols (those starting with D_ or func_). **Important:** symbols with `0x700...` addresses are splat placeholders and must be converted to runtime `0x800...` VRAM addresses before the linker can resolve them. A linker-script alias such as `osSendMesg = 0x800A0D30;` in `linker_scripts/libultra_syms.ld` is the wrong fix; update `symbol_addrs.txt`, the real asm/C labels, and call sites instead. Scan for any `0x700A` entries that the new source calls:

   ```text
   __osDisableInt = 0x800A61B0; // type:func
   __osRestoreInt = 0x800A61D0; // type:func
   __osContPifRam = 0x8015CA00;
   ```

   Before moving on, verify that no libultra function alias was added to the linker scripts, and that the matched/called functions use real names instead of address-derived placeholders:

   ```sh
   rg -n "= 0x800A" linker_scripts
   rg -n "func_800A[0-9A-Fa-f]+" symbol_addrs.txt src asm
   ```

   If the second command finds unrelated existing placeholders, do not rename them blindly. Fix only the symbols involved in the segment being matched.

6. Build and verify:

   ```sh
   ./tools/build-and-verify.sh
   ```

7. If verification fails, diff every function emitted by the new source before looking for linker or data issues:

   ```sh
   python3 tools/asm-differ/diff.py --no-pager osPfsNumFiles
   ```

8. Document Learnings:

Update the DECOMPILATION_LEARNINGA.md file in the root of the project with any additional learnings that you gathered as part of matching this segment.

## Build Flags

The game code uses -O2 but ultralib specifically should use -O1 instead. The build version can also affect libultra behavior, so check the compile line for both `-O1` and the expected `BUILD_VERSION` such as `BUILD_VERSION=VERSION_I`. You can use the following pattern to override the flags:

```make
$(BUILD_DIR)/src/ultra/io/%.o: C_OPT = -O1
```

## VERSION_I Specifics

This project uses `BUILD_VERSION=VERSION_I`. When porting upstream ultralib source, apply these adjustments:

- `__osPfsSelectBank` takes 1 argument (`OSPfs*`), not 2. The `SELECT_BANK` macro sets `pfs->activebank` then calls `__osPfsSelectBank(pfs)`.
- No `__osPfsCheckRamArea` function — skip any `BUILD_VERSION >= VERSION_J` blocks that call it.
- Uses `for` loops instead of `bcopy` for memory copies.
- No `PFS_ID_BROKEN` status flag handling.
- The upstream source may contain calls that were not present in the actual VERSION_I build. Trust the assembly over the upstream — if a call appears in upstream but not in the target assembly, omit it.

## Incorrect Segments

Be mindful that you may need to adjust the start/end points of segments as well as the segment name to match it to the correct ultralib c file.

## Data and Rodata matching

Ultralib segments may contain data and/or rodata which must be similarly matched. These are likely unlabelled. You will need to find the appropriate data/rodata segment and link it back to your matched ultralib segment, e.g:

```
- [0xE15B0, .rodata, myUltraLibSegment]
```

First check whether the compiled object actually emits these sections:

```sh
mips-linux-gnu-objdump -h build/src/ultra/io/pfsnumfiles.o
```

If the object only has `.text` plus compiler metadata such as `.options` and `.reginfo`, continue matching instruction generation before adding data or rodata segments.

You can use the match-data-file skill to help match  the correct segment. Note that it might not be properly annotated (yet) in snowboardkids.yaml.

## Avoid

- Do not mutate linker scripts with `perl -0pi`, `perl -pe`, or similar build hacks.
- Do not add libultra function aliases to `linker_scripts/libultra_syms.ld`; define the symbol in `symbol_addrs.txt` at its runtime `0x800...` address and rename the real labels/references.
- Do not replace archive-member linker entries by text substitution.
- Do not link `libultra_rom.a` just to extract one matched object.
- Do not add a custom `symbol_addrs.ld`; use `symbol_addrs.txt`.
- Do not disable `undefined_funcs_auto.txt` to keep a local libultra source dependency unresolved.
- Do not leave `func_...` or `D_...` references in `src/ultra`.

