#include "h264pred.h"
#include "h264pred_template.c"

void ff_h264_pred_init(pred16x16 *p_func)
{
	*p_func = pred16x16_dc;

#if ARCH_AARCH64
       ff_h264_pred_init_aarch64(p_func);
#endif
#if ARCH_ARM
       ff_h264_pred_init_arm(p_func);
#endif
#if ARCH_X86
       ff_h264_pred_init_x86(p_func);
#endif
}