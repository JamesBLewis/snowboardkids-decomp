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

1. Find the upstream source and headers:

   ```sh
   rg -n "osPfsNumFiles" ../ultralib/src ../ultralib/include
   ```

2. Copy or port the upstream file into `src/ultra`, preserving the source subtree:

   ```text
   ../ultralib/src/os/recvmesg.c -> src/ultra/os/recvmesg.c
   ../ultralib/src/io/pfsnumfiles.c -> src/ultra/io/pfsnumfiles.c
   ```

3. Replace the matching ROM range in `snowboardkids.yaml` with a normal C segment:

   ```yaml
   - [0xA1590, c, ultra/os/recvmesg]
   - [0xA2650, c, ultra/io/pfsnumfiles]
   ```

4. If the new source calls functions or references data already present elsewhere in the ROM, add the real ultralib symbol names to `symbol_addrs.txt`. Avoid using aliases to make the work with unlabeled symbols (those starting with D_ or func_):

   ```text
   __osDisableInt = 0x800A61B0; // type:func
   __osRestoreInt = 0x800A61D0; // type:func
   __osContPifRam = 0x8015CA00;
   ```

5. Build and verify:

   ```sh
   ./tools/build-and-verify.sh
   ```

## Build Flags

The game code uses -O2 but ultralib specifically should use -O1 instead. You can use the following pattern to override the flags:

```make
$(BUILD_DIR)/src/ultra/io/%.o: C_OPT = -O1
```

## Avoid

- Do not mutate linker scripts with `perl -0pi`, `perl -pe`, or similar build hacks.
- Do not replace archive-member linker entries by text substitution.
- Do not link `libultra_rom.a` just to extract one matched object.
- Do not add a custom `symbol_addrs.ld`; use `symbol_addrs.txt`.
- Do not disable `undefined_funcs_auto.txt` to keep a local libultra source dependency unresolved.
- Do not leave `func_...` or `D_...` references in `src/ultra`.
