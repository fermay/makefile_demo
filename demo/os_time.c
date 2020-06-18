#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <memory.h>
#include "os_time.h"


#if defined(WIN32) || defined(UNDER_CE) || defined(WIN64)
int os_sdk_inittimer(os_timer *pTimer)
{
	double tick;

	QueryPerformanceFrequency(&pTimer->lpFrequency);
	QueryPerformanceFrequency(&pTimer->tStart);

	tick = pTimer->tStart.QuadPart;
	tick *= (1000000.0 / 10.0);
	tick = tick / pTimer->lpFrequency.QuadPart;

	pTimer->pFrequency = fmod(tick, 1000);
    return 0;
}

int os_sdk_starttimer(os_timer *pTimer) //开始统计时间
{
   QueryPerformanceCounter(&pTimer->tStart);
   return 0;
}

int os_sdk_stoptimer(os_timer *pTimer) //停止统计时间
{
   QueryPerformanceCounter(&pTimer->tEnd);
   return (int)((pTimer->tEnd.QuadPart - pTimer->tStart.QuadPart)*1000000/(pTimer->lpFrequency.QuadPart)); //*1000 000表示时间精确到微秒
}

int os_sdk_sleep(int msecs)
{
   Sleep(msecs);
   return 0;
}
int os_check_file_exist(char *path)
{
   return (_access(path, 0) == -1)? 0 : 1;
}

#elif defined(__GNUC__)
int os_sdk_inittimer(os_timer *pTimer)  //初始化时间参数
{
	gettimeofday(&pTimer->pFrequency, NULL);
	clock_gettime(2, &(pTimer->lpFrequency));
	pTimer->pFrequency = ((pTimer->lpFrequency).tv_nsec) % 10000;
    return 0;
} 

int os_sdk_starttimer(os_timer *pTimer) //开始统计时间
{
   gettimeofday(&pTimer->tStart, NULL);
   return 0;
}
int os_sdk_stoptimer(os_timer *pTimer) //结束统计时间
{
    gettimeofday(&pTimer->tEnd, NULL);
    return (pTimer->tEnd.tv_sec - pTimer->tStart.tv_sec)*1000000 + (pTimer->tEnd.tv_usec - pTimer->tStart.tv_usec)/1000; //*1000 000精确到微秒级别
}
int os_sdk_sleep(int msecs)
{
  usleep(msecs*1000);
  return 0;
}
int os_check_file_exist(char *path)
{
  return (access(path , 0) == -1) ? 0 : -1;
}
#endif
