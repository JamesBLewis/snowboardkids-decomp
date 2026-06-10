/*====================================================================
 * synthesizer.c
 *
 * Copyright 1993, Silicon Graphics, Inc.
 * All Rights Reserved.
 * This is UNPUBLISHED PROPRIETARY SOURCE CODE of Silicon Graphics,
 * Inc.; the contents of this file may not be disclosed to third
 * parties, copied or duplicated in any form, in whole or in part,
 * without the prior written permission of Silicon Graphics, Inc.
 * RESTRICTED RIGHTS LEGEND:
 * Use, duplication or disclosure by the Government is subject to
 * restrictions as set forth in subdivision (c)(1)(ii) of the Rights
 * in Technical Data and Computer Software clause at DFARS
 * 252.227-7013, and/or in similar or successor clauses in the FAR,
 * DOD or NASA FAR Supplement. Unpublished - rights reserved under the
 * Copyright Laws of the United States.
 *====================================================================*/
#include "synthInternals.h"
#include <assert.h>
#include <PR/os_version.h>
// TODO: this comes from a header
#ident "$Revision: 1.17 $"

#ifdef AUD_PROFILE
#include <os.h>
extern u32 cnt_index, drvr_num, drvr_cnt, drvr_max, drvr_min, lastCnt[];
extern u32 client_num, client_cnt, client_max, client_min;
#endif

#ifndef MIN
#   define MIN(a,b) (((a)<(b))?(a):(b))
#endif


void func_800A5A90(void)
{
}

/*
  Add 0.5 to adjust the average affect of
  the truncation error produced by casting
  a float to an int.
*/
s32 _timeToSamples(ALSynth *synth, s32 micros)
{
    f32 tmp = ((f32)micros) * synth->outputRate / 1000000.0 + 0.5;

    return (s32)tmp & ~0xf;
}

void _freePVoice(ALSynth *drvr, PVoice *pvoice)
{
    alUnlink((ALLink *)pvoice);
    alLink((ALLink *)pvoice, &drvr->pLameList);
}

void _collectPVoices(ALSynth *drvr)
{
    ALLink *dl;

    while ((dl = drvr->pLameList.next) != 0) {
        alUnlink(dl);
        alLink(dl, &drvr->pFreeList);
    }
}

void __freeParam(ALParam *param)
{
    ALSynth *drvr = &alGlobals->drvr;

    param->next = drvr->paramList;
    drvr->paramList = param;
}

ALParam *__allocParam(void)
{
    ALParam *update = 0;
    ALSynth *drvr = &alGlobals->drvr;

    if (drvr->paramList) {
        update = drvr->paramList;
        drvr->paramList = drvr->paramList->next;
        update->next = 0;
    }
    return update;
}

void func_800A5BD0(void)
{
}



/*
 * slAudioFrame() is called every video frame, and is based on the video
 * frame interrupt. It is assumed to be an accurate time source for the
 * clients.
 */
#if 0
Acmd *alAudioFrame(Acmd *cmdList, s32 *cmdLen, s16 *outBuf, s32 outLen)
{
    ALPlayer *volatile client;
    ALPlayer *cl;
    ALFilter *output;
    ALSynth *drvr = &alGlobals->drvr;
    s16 tmp = 0;
    Acmd *cmdlEnd = cmdList;
    Acmd *cmdPtr;
    s32 nOut;
    s16 *lOutBuf = outBuf;
    s16 *tmpPtr = &tmp;
    ALMicroTime delta;
    s32 samples;
    f64 denom;
    f64 round;
    f32 samplesFloat;
    ALPlayer *volatile clientPad[6];

#ifdef AUD_PROFILE
    lastCnt[++cnt_index] = osGetCount();
#endif

    if (drvr->head == 0) {
        *cmdLen = 0;
        return cmdList;
    }

#ifdef AUD_PROFILE
    lastCnt[++cnt_index] = osGetCount();
#endif

    client = 0;
    delta = 0x7fffffff;
    for (cl = drvr->head; cl != 0; cl = cl->next) {
        if ((cl->samplesLeft - drvr->curSamples) < delta) {
            client = cl;
            delta = cl->samplesLeft - drvr->curSamples;
        }
    }
    drvr->paramSamples = client->samplesLeft;

    if (drvr->paramSamples - drvr->curSamples < outLen) {
        denom = 1000000.0;
        round = 0.5;
        do {
            drvr->paramSamples &= ~0xf;
            samples = (*client->handler)(client);
            samplesFloat = (f32)((((f32)samples) * drvr->outputRate / denom) + round);
            client->samplesLeft += (s32)samplesFloat;

            client = 0;
            delta = 0x7fffffff;
            for (cl = drvr->head; cl != 0; cl = cl->next) {
                if ((cl->samplesLeft - drvr->curSamples) < delta) {
                    client = cl;
                    delta = cl->samplesLeft - drvr->curSamples;
                }
            }
            drvr->paramSamples = client->samplesLeft;
        } while (drvr->paramSamples - drvr->curSamples < outLen);
    }

    ((volatile ALSynth *)drvr)->paramSamples &= ~0xf;

#ifdef AUD_PROFILE
    PROFILE_AUD(client_num, client_cnt, client_max, client_min);
#endif

    while (outLen > 0) {
        nOut = MIN(drvr->maxOutSamples, outLen);
        cmdPtr = cmdlEnd;
        aSegment(cmdPtr++, 0, 0);
        output = drvr->outputFilter;
        (*output->setParam)(output, AL_FILTER_SET_DRAM, lOutBuf);
        cmdlEnd = (*output->handler)(output, tmpPtr, nOut, drvr->curSamples,
                                     cmdPtr);

        outLen -= nOut;
        lOutBuf += nOut << 1;
        drvr->curSamples += nOut;
    }
    *cmdLen = (s32)(cmdlEnd - cmdList);

    _collectPVoices(drvr);

#ifdef AUD_PROFILE
    PROFILE_AUD(drvr_num, drvr_cnt, drvr_max, drvr_min);
#endif
    return cmdlEnd;
}
#endif

#pragma GLOBAL_ASM("asm/nonmatchings/ultra/audio/synthesizer/alAudioFrame.s")

/***********************************************************************
 * Synthesis driver public interfaces
 ***********************************************************************/
void alSynNew(ALSynth *drvr, ALSynConfig *c)
{
    s32 i;
    ALVoice *vv;
    PVoice *pv;
    ALVoice *vvoices;
    PVoice *pvoices;
    ALHeap *hp = c->heap;
    ALSave *save;
    ALFilter **sources;
    ALParam *params;
    ALParam *paramPtr;

    drvr->head = NULL;
    drvr->numPVoices = c->maxPVoices;
    drvr->curSamples = 0;
    drvr->paramSamples = 0;
    drvr->outputRate = c->outputRate;
    drvr->maxOutSamples = AL_MAX_RSP_SAMPLES;
    drvr->dma = (ALDMANew)c->dmaproc;

    save = alHeapAlloc(hp, 1, sizeof(ALSave));
    alSaveNew(save);
    drvr->outputFilter = (ALFilter *)save;

    drvr->auxBus = alHeapAlloc(hp, 1, sizeof(ALAuxBus));
    drvr->maxAuxBusses = 1;
    sources = alHeapAlloc(hp, c->maxPVoices, sizeof(ALFilter *));
    alAuxBusNew(drvr->auxBus, sources, c->maxPVoices);

    drvr->mainBus = alHeapAlloc(hp, 1, sizeof(ALMainBus));
    sources = alHeapAlloc(hp, c->maxPVoices, sizeof(ALFilter *));
    alMainBusNew(drvr->mainBus, sources, c->maxPVoices);

    if (c->fxType != AL_FX_NONE) {
        alSynAllocFX(drvr, 0, c, hp);
    } else {
        alMainBusParam(drvr->mainBus, AL_FILTER_ADD_SOURCE, &drvr->auxBus[0]);
    }

    drvr->pFreeList.next = 0;
    drvr->pFreeList.prev = 0;
    drvr->pLameList.next = 0;
    drvr->pLameList.prev = 0;
    drvr->pAllocList.next = 0;
    drvr->pAllocList.prev = 0;

    pvoices = alHeapAlloc(hp, c->maxPVoices, sizeof(PVoice));
    for (i = 0; i < c->maxPVoices; i++) {
        pv = &pvoices[i];
        alLink((ALLink *)pv, &drvr->pFreeList);
        pv->vvoice = 0;

        alLoadNew(&pv->decoder, drvr->dma, hp);
        alLoadParam(&pv->decoder, AL_FILTER_SET_SOURCE, 0);

        alResampleNew(&pv->resampler, hp);
        alResampleParam(&pv->resampler, AL_FILTER_SET_SOURCE, &pv->decoder);

        alEnvmixerNew(&pv->envmixer, hp);
        alEnvmixerParam(&pv->envmixer, AL_FILTER_SET_SOURCE, &pv->resampler);

        alAuxBusParam(drvr->auxBus, AL_FILTER_ADD_SOURCE, &pv->envmixer);
        pv->channelKnob = (ALFilter *)&pv->envmixer;
    }

    alSaveParam(save, AL_FILTER_SET_SOURCE, drvr->mainBus);

    params = alHeapAlloc(hp, c->maxUpdates, sizeof(ALParam));
    drvr->paramList = 0;
    for (i = 0; i < c->maxUpdates; i++) {
        paramPtr = &params[i];
        paramPtr->next = drvr->paramList;
        drvr->paramList = paramPtr;
    }

    drvr->heap = hp;
}
