#ifndef API_H
#define API_H
#include <stdint.h>

//声明函数指针
typedef void(*pred16x16)(uint8_t *src, int stride);

//此函数根据系统支持的最大汇编指令集，将p_func设置为对应指令集优化后的函数指针
void ff_h264_pred_init(pred16x16 *p_func);

#endif /* API_H */