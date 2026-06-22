#include "common.h"

typedef struct {
    char pad[0x18];
    s16 unk18;
    s16 unk1A;
    s32 unk1C;
    char pad20[4];
    s8 unk24;
    char pad25[1];
    s16 unk26;
    char pad28[2];
    s8 unk2A;
    char pad2B[1];
    s8 unk2C;
} Obj;

extern void func_800483FC(void *, void *, void *);
extern void func_80071824(void *, void *);

extern void func_8000DF9C(void *);
extern void func_8000E5A0(void *);
extern void func_8000E8CC(void *);
void func_8000E99C(Obj *);
void func_8000E9F4(Obj *);

extern u8 D_80124868;
extern u8 D_800B4FB8;
extern u8 D_8010B1F0;

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

void func_8000E874(Obj *arg) {
    arg->unk18 = -0x80;
    arg->unk1A = -0x24;
    arg->unk2A = 0;
    arg->unk24 = 1;
    arg->unk26 = 7;
    arg->unk1C = (s32) &D_800B4FB8;
    arg->unk2C = 1;
    func_80071824(arg, &func_8000E5A0);
}

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000E8CC.s")

#pragma GLOBAL_ASM("asm/nonmatchings/E3F0/func_8000E99C.s")

void func_8000E9F4(Obj *arg) {
    if (D_8010B1F0 == 1) {
        func_80071824(arg, &func_8000E99C);
    }
    func_800483FC(&D_80124868, &func_8000E8CC, arg);
}

void func_8000EA44(Obj *arg) {
    arg->unk18 = -0x48;
    arg->unk1A = -0x48;
    arg->unk1C = 0x78;
    func_80071824(arg, &func_8000E9F4);
}
