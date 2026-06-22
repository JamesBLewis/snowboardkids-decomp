#include "common.h"

typedef struct {
    char pad[0x18];
    s16 unk18;
    s16 unk1A;
} Obj;

extern void func_80071824(void *, void *);
extern void func_800483FC(void *, void *, void *);

void func_80011C3C(Obj *);
void func_80011D44(void *);

extern s32 D_80123758;
extern u8 D_80124868;


#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_8000EA80.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_8000F030.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_8000F0EC.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_8000F8AC.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_8000F970.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80010074.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_8001061C.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80010BCC.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80011264.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_800112F4.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80011854.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_8001185C.s")

void func_80011C18(void *arg) {
    func_80071824(arg, &func_80011C3C);
}

void func_80011C3C(Obj *arg) {
    if (D_80123758 & 0x8) {
        arg->unk1A++;
    }
    if (D_80123758 & 0x4) {
        arg->unk1A--;
    }
    if (D_80123758 & 0x1) {
        arg->unk18++;
    }
    if (D_80123758 & 0x2) {
        arg->unk18--;
    }
    if (arg->unk18 >= 0x141) {
        arg->unk18 = 0;
    }
    if (arg->unk18 < 0) {
        arg->unk18 = 0x13F;
    }
    if (arg->unk1A >= 0x9C1) {
        arg->unk1A = 0;
    }
    if (arg->unk1A < 0) {
        arg->unk1A = 0x9BF;
    }
    func_800483FC(&D_80124868, &func_80011D44, &arg->unk18);
}

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80011D44.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80011D74.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_800128C8.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_800129DC.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80012AE4.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_8001303C.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80013154.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80013284.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_800137C8.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80013D0C.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80013DFC.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80013F88.s")

#pragma GLOBAL_ASM("asm/nonmatchings/F680/func_80013FEC.s")
