#ifndef __SYNTH_INTERNALS__
#define __SYNTH_INTERNALS__

#include <PR/libaudio.h>

#define AL_MAX_RSP_SAMPLES 160
#define AL_DECODER_IN 0
#define AL_RESAMPLER_OUT 0
#define AL_TEMP_0 0
#define AL_DECODER_OUT 320
#define AL_TEMP_1 320
#define AL_TEMP_2 640
#define AL_MAIN_L_OUT 1088
#define AL_MAIN_R_OUT 1408
#define AL_AUX_L_OUT 1728
#define AL_AUX_R_OUT 2048

enum {
    AL_FILTER_FREE_VOICE,
    AL_FILTER_SET_SOURCE,
    AL_FILTER_ADD_SOURCE,
    AL_FILTER_ADD_UPDATE,
    AL_FILTER_RESET,
    AL_FILTER_SET_WAVETABLE,
    AL_FILTER_SET_DRAM,
    AL_FILTER_SET_PITCH,
    AL_FILTER_SET_UNITY_PITCH,
    AL_FILTER_START,
    AL_FILTER_SET_STATE,
    AL_FILTER_SET_VOLUME,
    AL_FILTER_SET_PAN,
    AL_FILTER_START_VOICE_ALT,
    AL_FILTER_START_VOICE,
    AL_FILTER_STOP_VOICE,
    AL_FILTER_SET_FXAMT
};

typedef struct ALParam_s {
    struct ALParam_s    *next;
    s32                 delta;
    s16                 type;
    union {
        f32             f;
        s32             i;
    } data;
    union {
        f32             f;
        s32             i;
    } moredata;
    union {
        f32             f;
        s32             i;
    } stillmoredata;
    union {
        f32             f;
        s32             i;
    } yetstillmoredata;
} ALParam;

typedef Acmd *(*ALCmdHandler)(void *, s16 *, s32, s32, Acmd *);
typedef s32   (*ALSetParam)(void *, s32, void *);

typedef struct ALFilter_s {
    struct ALFilter_s   *source;
    ALCmdHandler        handler;
    ALSetParam          setParam;
    s16                 inp;
    s16                 outp;
    s32                 type;
} ALFilter;

typedef struct PVoice_s {
    ALLink               node;
    struct ALVoice_s    *vvoice;
    ALFilter            *channelKnob;
    char                 _pad[0xD8 - 0x10];
    s32                  offset;
} PVoice;

typedef struct {
    struct ALParam_s    *next;
    s32                 delta;
    s16                 type;
    s16                 unity;
    ALWaveTable         *wave;
} ALStartParam;

typedef struct ALSave_s {
    ALFilter            filter;
    s32                 dramout;
    s32                 first;
} ALSave;

ALParam *__allocParam(void);
s32 _timeToSamples(ALSynth *synth, s32 micros);

#endif
