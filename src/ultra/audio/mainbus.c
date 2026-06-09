#include "synthInternals.h"
#include "PR/libaudio.h"

s32 alMainBusParam(void *filter, s32 paramID, void *param) {
    ALMainBus *m = (ALMainBus *) filter;
    ALFilter **sources = m->sources;

    switch (paramID) {
        case AL_FILTER_ADD_SOURCE:
            sources[m->sourceCount++] = (ALFilter *) param;
            break;
        default:
            break;
    }

    return 0;
}

#ifdef NON_MATCHING
Acmd *alMainBusPull(void *filter, s16 *outp, s32 outCount, s32 sampleOffset, Acmd *p) {
    ALMainBus *m = (ALMainBus *) filter;
    ALFilter **sources = m->sources;
    u32 *cmd = (u32 *) p;
    Acmd *ptr;
    s32 i;

    cmd[0] = 0x02000440;
    cmd[1] = outCount << 1;
    cmd[2] = 0x02000580;
    cmd[3] = outCount << 1;
    ptr = (Acmd *) &cmd[4];

    for (i = 0; i < m->sourceCount; i++) {
        ptr = (*sources[i]->handler)(sources[i], outp, outCount, sampleOffset, ptr);
        aSetBuffer(ptr++, 0, 0, 0, outCount << 1);
        aMix(ptr++, 0, 0x7fff, AL_AUX_L_OUT, AL_MAIN_L_OUT);
        aMix(ptr++, 0, 0x7fff, AL_AUX_R_OUT, AL_MAIN_R_OUT);
    }

    return ptr;
}
#else
#pragma GLOBAL_ASM("asm/nonmatchings/ultra/audio/mainbus/alMainBusPull.s")
#endif
