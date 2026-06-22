#include "common.h"

typedef struct {
    char pad[0x18];
    s16 unk18;
    s16 unk1A;
    s32 unk1C;
} Obj;

extern void func_800483FC(void *, void *, void *);
extern void func_80071824(void *, void *);

extern void func_8000DF9C(void *);
extern void func_8000E9F4(void *);

extern u8 D_80124868;

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000D7F0.s")

void func_8000DD74(void *arg) {
    func_800483FC(&D_80124868, &func_8000DD74, arg);
}

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000DDA4.s")

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000DF28.s")

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000DF9C.s")

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000E548.s")

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000E5A0.s")

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000E7CC.s")

void func_8000E844(void *arg) {
    func_800483FC(&D_80124868, &func_8000DF9C, arg);
}

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000E874.s")

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000E8CC.s")

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000E99C.s")

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000E9F4.s")

void func_8000EA44(Obj *arg) {
    arg->unk18 = -0x48;
    arg->unk1A = -0x48;
    arg->unk1C = 0x78;
    func_80071824(arg, &func_8000E9F4);
}
