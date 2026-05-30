#ifndef INCLUDE_ASM_H
#define INCLUDE_ASM_H

#if !defined(M2CTX) && !defined(PERMUTER)

#ifndef INCLUDE_ASM
#define INCLUDE_ASM(FOLDER, NAME) \
    asm( \
        ".include \"include/macro.inc\"\n" \
        ".section .text\n" \
        ".set noat\n" \
        ".set noreorder\n" \
        ".include \"" FOLDER "/" #NAME ".s\"\n" \
        ".set reorder\n" \
        ".set at\n" \
    )
#endif

#ifndef INCLUDE_RODATA
#define INCLUDE_RODATA(FOLDER, NAME) \
    asm( \
        ".include \"include/macro.inc\"\n" \
        ".section .rodata\n" \
        ".include \"" FOLDER "/" #NAME ".s\"\n" \
        ".section .text\n" \
    )
#endif

#else

#ifndef INCLUDE_ASM
#define INCLUDE_ASM(FOLDER, NAME)
#endif

#ifndef INCLUDE_RODATA
#define INCLUDE_RODATA(FOLDER, NAME)
#endif

#endif

#endif
