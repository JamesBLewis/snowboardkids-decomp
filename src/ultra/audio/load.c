/*====================================================================
 * load.c
 *
 * Copyright 1993, Silicon Graphics, Inc.
 * All Rights Reserved.
 *
 * This is UNPUBLISHED PROPRIETARY SOURCE CODE of Silicon Graphics,
 * Inc.; the contents of this file may not be disclosed to third
 * parties, copied or duplicated in any form, in whole or in part,
 * without the prior written permission of Silicon Graphics, Inc.
 *
 * RESTRICTED RIGHTS LEGEND:
 * Use, duplication or disclosure by the Government is subject to
 * restrictions as set forth in subdivision (c)(1)(ii) of the Rights
 * in Technical Data and Computer Software clause at DFARS
 * 252.227-7013, and/or in similar or successor clauses in the FAR,
 * DOD or NASA FAR Supplement. Unpublished - rights reserved under the
 * Copyright Laws of the United States.
 *====================================================================*/

#include <libaudio.h>
#include "synthInternals.h"
#include <os.h>
#include <R4300.h>

#ifndef MIN
#   define MIN(a,b) (((a)<(b))?(a):(b))
#endif

#ifdef AUD_PROFILE
extern u32 cnt_index, adpcm_num, adpcm_cnt, adpcm_max, adpcm_min, lastCnt[];
#endif

#define ADPCMFBYTES      9
#define LFSAMPLES        4

Acmd *_decodeChunk(Acmd *ptr, ALLoadFilter *f, s32 tsam, s32 nbytes, s16 outp, s16 inp, u32 flags);
Acmd *alAdpcmPull(void *filter, s16 *outp, s32 outCount, s32 sampleOffset, Acmd *p);
Acmd *alRaw16Pull(void *filter, s16 *outp, s32 outCount, s32 sampleOffset, Acmd *p);

s32
alLoadParam(void *filter, s32 paramID, void *param)
{
    ALLoadFilter *a = (ALLoadFilter *) filter;
    ALFilter *f = (ALFilter *) filter;
    
    switch (paramID) {
        case (AL_FILTER_SET_WAVETABLE):
            a->table = (ALWaveTable *) param;
            a->memin = (s32) a->table->base;
            a->sample = 0;
            switch (a->table->type){
                case (AL_ADPCM_WAVE):

                    /*
                     * Set up the correct handler
                     */
                    f->handler = alAdpcmPull;
                    
                    /*
                     * Make sure the table length is an integer number of
                     * frames
                     */
                    a->table->len = ADPCMFBYTES *
                        ((s32) (a->table->len/ADPCMFBYTES));
                    
                    a->bookSize = 2*a->table->waveInfo.adpcmWave.book->order*
                    a->table->waveInfo.adpcmWave.book->npredictors*ADPCMVSIZE;
                    if (a->table->waveInfo.adpcmWave.loop) {
                        a->loop.start = a->table->waveInfo.adpcmWave.loop->start;
                        a->loop.end = a->table->waveInfo.adpcmWave.loop->end;
                        a->loop.count = a->table->waveInfo.adpcmWave.loop->count;
                        alCopy(a->table->waveInfo.adpcmWave.loop->state,
                               a->lstate, sizeof(ADPCM_STATE));
                    } else {
                        a->loop.start = a->loop.end = a->loop.count = 0;
                    }
                    break;
                    
                case (AL_RAW16_WAVE):
                    f->handler = alRaw16Pull;
                    if (a->table->waveInfo.rawWave.loop) {
                        a->loop.start = a->table->waveInfo.rawWave.loop->start;
                        a->loop.end = a->table->waveInfo.rawWave.loop->end;
                        a->loop.count = a->table->waveInfo.rawWave.loop->count;
                    } else {
                        a->loop.start = a->loop.end = a->loop.count = 0;
                    }
                    break;
                    
                default:
                    break;

            }
            break;
            
        case (AL_FILTER_RESET):
            a->lastsam = 0;
            a->first   = 1;
            a->sample = 0;
	    
	    /* sct 2/14/96 - Check table since it is initialized to null and */
	    /* Get loop info according to table type. */
	    if (a->table)
	    {
		a->memin  = (s32) a->table->base;
		if (a->table->type == AL_ADPCM_WAVE)
		{
		    if (a->table->waveInfo.adpcmWave.loop)
			a->loop.count = a->table->waveInfo.adpcmWave.loop->count;
		}
		else if (a->table->type == AL_RAW16_WAVE)
		{
		    if (a->table->waveInfo.rawWave.loop)
			a->loop.count = a->table->waveInfo.rawWave.loop->count;
		}
	    }
	    
            break;
            
        default:
            break;
    }
}

#pragma GLOBAL_ASM("src/ultra/audio/load/alRaw16Pull.s")
#pragma GLOBAL_ASM("src/ultra/audio/load/_decodeChunk.s")
#pragma GLOBAL_ASM("src/ultra/audio/load/alAdpcmPull.s")
