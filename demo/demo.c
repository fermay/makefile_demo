#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "os_time.h"
#include "../src/API.h"

#define CLIP(x) (x>255? 255: x<0? 0:x)
static void generate_matrix(unsigned char *src, unsigned char *top,unsigned char *left, int stride, int height)
{
	int i = 0;
	srand((int)time(0)); // 设置rand()产生随机数的随机数种子

	for (i = 0; i < height*stride; i++)
	{
		src[i] = CLIP(1.0*rand()/RAND_MAX * 255);
	}
	for (i = 0; i < height*stride; i++)
	{
		top[i] = CLIP(1.0*rand()/RAND_MAX * 255);
	}
	for (i = 0; i < height*stride; i++)
	{
		left[i] = CLIP(1.0*rand()/RAND_MAX * 255);
	}

}

#define BLOCK_SIZE  20
#define LOOP_CIRCLE 1
int main(int argc, char* argv[])
{
	int ret = 0;
	int i = 0, j = 0;
	unsigned char src[BLOCK_SIZE*BLOCK_SIZE];
	unsigned char top[BLOCK_SIZE*BLOCK_SIZE];
	unsigned char left[BLOCK_SIZE*BLOCK_SIZE];
	os_timer pTimer = {0};
	double time_opt = 0.0;
	pred16x16 p_func = NULL;
	generate_matrix(src, top, left, BLOCK_SIZE, BLOCK_SIZE);

	ff_h264_pred_init(&p_func); //接口函数
	os_sdk_inittimer(&pTimer);

	os_sdk_starttimer(&pTimer);
	p_func(&src[1], 20);
	time_opt = os_sdk_stoptimer(&pTimer);

	for (i = 0; i < BLOCK_SIZE ; i++)
	{
		for (j = 0; j < BLOCK_SIZE; j++)
		{
			printf("%d,", src[j+i*BLOCK_SIZE]);
		}
		printf("\n");
	}

	printf("time_opt: %f us \n", time_opt);
	return 0;
}