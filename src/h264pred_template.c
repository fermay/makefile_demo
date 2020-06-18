#include <stdio.h>
#include <stdint.h>

typedef union {
    uint32_t u32;
    uint16_t u16[2];
    uint8_t  u8 [4];
    float    f32;
} av_alias32;

#   define pixel  uint8_t
#   define pixel4 uint32_t

#define AV_WNA(s, p, v) (((av_alias##s*)(p))->u##s = (v))

#ifndef AV_WN32A
#   define AV_WN32A(p, v) AV_WNA(32, p, v)
#endif

#   define AV_WN4PA AV_WN32A
#   define PIXEL_SPLAT_X4(x) ((x)*0x01010101U)

#define PREDICT_16x16_DC(v)\
    for(i=0; i<16; i++){\
        AV_WN4PA(src+ 0, v);\
        AV_WN4PA(src+ 4, v);\
        AV_WN4PA(src+ 8, v);\
        AV_WN4PA(src+12, v);\
        src += stride;\
    }
	
static void pred16x16_dc(uint8_t *_src, int stride)
{
    int i, dc=0;
    pixel *src = (pixel*)_src;
    pixel4 dcsplat;
    stride >>= sizeof(pixel)-1;

    for(i=0;i<16; i++){
        dc+= src[-1+i*stride];
    }

    for(i=0;i<16; i++){
        dc+= src[i-stride];
    }

    dcsplat = PIXEL_SPLAT_X4((dc+16)>>5);
    PREDICT_16x16_DC(dcsplat);
}