#ifndef _OS_TIME_SDK_H_
#define _OS_TIME_SDK_H_

#ifdef __cplusplus
extern "C"{
#endif

#if defined(WIN32) || defined(UNDER_CE) || defined(WIN64)
#include <windows.h>
typedef struct _os_timer
{
	long pFrequency;
    LARGE_INTEGER lpFrequency;
    LARGE_INTEGER tStart;
    LARGE_INTEGER tEnd;
}os_timer;

#elif defined(__GNUC__)
#include <unistd.h>
//#include <sys/types.h>
#include <sys/stat.h>
#include <sys/times.h>
#include <sys/time.h>
#include <sys/sysinfo.h>

typedef struct _os_timer
{
	long pFrequency;
	struct timespec lpFrequency; //Linux下为了产生随机数的种�?
    struct timeval tStart;
    struct timeval tEnd;
}os_timer;
#endif

int os_sdk_inittimer(os_timer *pTimer);
int os_sdk_starttimer(os_timer *pTimer);
int os_sdk_stoptimer(os_timer *pTimer);
int os_sdk_sleep(int msecs);
int os_check_file_exist(char *path);


#ifdef __cplusplus
};
#endif

#endif
