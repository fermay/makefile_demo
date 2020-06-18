#include <stdint.h>
#include "../h264pred.h"
#include "../../utils/cpu.h"

void ff_pred16x16_dc_neon(uint8_t *src, int stride);


static void h264_pred_init_neon(pred16x16* p_func)
{
#if HAVE_NEON
	 *p_func = ff_pred16x16_dc_neon; 
#endif	
}


void ff_h264_pred_init_arm(pred16x16* p_func)
{
    int cpu_flags = x264_cpu_detect();

    if (cpu_flags & X264_CPU_NEON)
        h264_pred_init_neon(p_func);
}


