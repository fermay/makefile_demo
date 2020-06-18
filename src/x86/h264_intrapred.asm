%include "../../utils/x86/x86inc.asm"
%include "../../utils/x86/x86util.asm"
SECTION_RODATA 64


SECTION .text

;-----------------------------------------------------------------------------
; void ff_pred16x16_dc_8(uint8_t *src, int stride)
;-----------------------------------------------------------------------------

%macro PRED16x16_DC 0
cglobal pred16x16_dc_8, 2,7
    mov       r4, r0
    sub       r0, r1
    pxor      mm0, mm0
    pxor      mm1, mm1
    psadbw    mm0, [r0+0]
    psadbw    mm1, [r0+8]
    dec        r0
    movzx     r5d, byte [r0+r1*1]
    paddw     mm0, mm1
    movd      r6d, mm0
    lea        r0, [r0+r1*2]
%rep 7
    movzx     r2d, byte [r0+r1*0]
    movzx     r3d, byte [r0+r1*1]
    add       r5d, r2d
    add       r6d, r3d
    lea        r0, [r0+r1*2]
%endrep
    movzx     r2d, byte [r0+r1*0]
    add       r5d, r6d
    lea       r2d, [r2+r5+16]
    shr       r2d, 5
%if cpuflag(ssse3)
    pxor       m1, m1
%endif
    SPLATB_REG m0, r2, m1

%if mmsize==8
    mov       r3d, 8
.loop:
    movu [r4+r1*0+0], m0
    movu [r4+r1*0+8], m0
    movu [r4+r1*1+0], m0
    movu [r4+r1*1+8], m0
%else
    mov       r3d, 4
.loop:
    movu [r4+r1*0], m0
    movu [r4+r1*1], m0
    lea   r4, [r4+r1*2]
    movu [r4+r1*0], m0
    movu [r4+r1*1], m0
%endif
    lea   r4, [r4+r1*2]
    dec   r3d
    jg .loop
    REP_RET
%endmacro

INIT_XMM sse2
PRED16x16_DC