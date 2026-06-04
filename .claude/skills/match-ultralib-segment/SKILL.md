---
name: match-ultralib-segment
description: Match a given segment to a libultra ROM segment. Use this when converting unidentified asm libultra ranges such as osRecvMesg to matching C source.
---

# Match an Ultralib Segment

## Core Rules

- Match libultra by compiling local source under `src/ultra`; do not patch generated linker scripts or use archive-member rewrites.
- Preserve the upstream libultra subdirectory when possible, for example `../ultralib/src/io/pfsnumfiles.c` becomes `src/ultra/io/pfsnumfiles.c`.
- Keep unidentified neighboring libultra functions as separate `asm` segments until each function is matched as source.
- Source under `src/ultra` should use real libultra names, not `func_...` or `D_...` placeholders.
- Add required callable ROM symbols to `symbol_addrs.txt` with runtime VRAM addresses, not `0x700...` splat placeholder addresses.

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

3. Copy or port the upstream file into `src/ultra`, preserving the source subtree. Verify macro values in local headers before using semantic-looking names; for example `CONT_CMD_NOP` may be `0xff`, while the target may want a literal `0`.

   ```text
   ../ultralib/src/os/recvmesg.c -> src/ultra/os/recvmesg.c
   ../ultralib/src/io/pfsnumfiles.c -> src/ultra/io/pfsnumfiles.c
   ```

4. Replace the matching ROM range in `snowboardkids.yaml` with a normal C segment:

   ```yaml
   - [0xA1590, c, ultra/os/recvmesg]
   - [0xA2650, c, ultra/io/pfsnumfiles]
   ```

5. If the new source calls functions or references data already present elsewhere in the ROM, add the real ultralib symbol names to `symbol_addrs.txt`. Avoid using aliases to make the work with unlabeled symbols (those starting with D_ or func_):

   ```text
   __osDisableInt = 0x800A61B0; // type:func
   __osRestoreInt = 0x800A61D0; // type:func
   __osContPifRam = 0x8015CA00;
   ```

6. Build and verify:

   ```sh
   ./tools/build-and-verify.sh
   ```

7. If verification fails, diff every function emitted by the new source before looking for linker or data issues:

   ```sh
   python3 tools/asm-differ/diff.py --no-pager osPfsNumFiles
   ```

## Build Flags

The game code uses -O2 but ultralib specifically should use -O1 instead. The build version can also affect libultra behavior, so check the compile line for both `-O1` and the expected `BUILD_VERSION` such as `BUILD_VERSION=VERSION_I`. You can use the following pattern to override the flags:

```make
$(BUILD_DIR)/src/ultra/io/%.o: C_OPT = -O1
```

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

## Avoid

- Do not mutate linker scripts with `perl -0pi`, `perl -pe`, or similar build hacks.
- Do not replace archive-member linker entries by text substitution.
- Do not link `libultra_rom.a` just to extract one matched object.
- Do not add a custom `symbol_addrs.ld`; use `symbol_addrs.txt`.
- Do not disable `undefined_funcs_auto.txt` to keep a local libultra source dependency unresolved.
- Do not leave `func_...` or `D_...` references in `src/ultra`.
