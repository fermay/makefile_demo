#include <stdint.h>
#include "../h264pred.h"
#include "../../utils/cpu.h"

#define PRED16x16(TYPE, DEPTH, OPT)\
void ff_pred16x16_ ## TYPE ## _ ## DEPTH ## _ ## OPT (uint8_t *src, \
                                                      int stride);

PRED16x16(dc, 8, sse2)

void ff_h264_pred_init_x86(pred16x16* p_func)
{
	int cpu_flags = x264_cpu_detect();
	
	if (cpu_flags & X264_CPU_SSE2) {
        *p_func = ff_pred16x16_dc_8_sse2;
	}
}


