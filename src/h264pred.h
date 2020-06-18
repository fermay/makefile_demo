#ifndef AVCODEC_H264PRED_H
#define AVCODEC_H264PRED_H
#include <stdint.h>
#include "API.h"
					   
void ff_h264_pred_init_aarch64(pred16x16 *p_func);
void ff_h264_pred_init_arm(pred16x16 *p_func);
void ff_h264_pred_init_x86(pred16x16 *p_func);
					   
#endif /* AVCODEC_H264PRED_H */
					   