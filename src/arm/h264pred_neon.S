#include "../../utils/arm/asm.S"

        .macro ldcol.8  rd,  rs,  rt,  n=8,  hi=0
.if \n == 8 || \hi == 0
        vld1.8          {\rd[0]}, [\rs], \rt
        vld1.8          {\rd[1]}, [\rs], \rt
        vld1.8          {\rd[2]}, [\rs], \rt
        vld1.8          {\rd[3]}, [\rs], \rt
.endif
.if \n == 8 || \hi == 1
        vld1.8          {\rd[4]}, [\rs], \rt
        vld1.8          {\rd[5]}, [\rs], \rt
        vld1.8          {\rd[6]}, [\rs], \rt
        vld1.8          {\rd[7]}, [\rs], \rt
.endif
        .endm

function ff_pred16x16_dc_neon, export=1
        sub             r2,  r0,  r1
        vld1.8          {q0},     [r2,:128]
        sub             r2,  r0,  #1
        ldcol.8         d2,  r2,  r1
        ldcol.8         d3,  r2,  r1
        vaddl.u8        q0,  d0,  d1
        vaddl.u8        q1,  d2,  d3
        vadd.u16        q0,  q0,  q1
        vadd.u16        d0,  d0,  d1
        vpadd.u16       d0,  d0,  d0
        vpadd.u16       d0,  d0,  d0
        vrshrn.u16      d0,  q0,  #5
        vdup.8          q0,  d0[0]
.L_pred16x16_dc_end:
        mov             r3,  #8
6:      vst1.8          {q0},     [r0,:128], r1
        vst1.8          {q0},     [r0,:128], r1
        subs            r3,  r3,  #1
        bne             6b
        bx              lr
endfunc