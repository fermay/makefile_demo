LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := libxTest

##参数初始化
DEBUG ?= 0
SHARED ?= 1
ASM_DIR := 


#设置汇编优化使能
ifeq ($(PURE_C),1)
OPTIM := 0
else
OPTIM := 1
endif

#设置GDB调试使能
ifeq ($(DEBUG),1)
GDBEN := -g
else
GDBEN := -O3
endif

#设置公用编译参数
CFLAGS := -Wall
CFLAGS += -fPIC
CFLAGS += -std=c99
CFLAGS += $(GDBEN)

#特定架构编译参数
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
ASM_DIR = aarch64
CFLAGS += -march=armv8-a
CFLAGS += -D_REENTRANT
endif

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
ASM_DIR = arm
CFLAGS += -march=armv7-a -mfpu=neon -marm
CFLAGS +=  -DARCH_ARM=$(OPTIM) -DARCH_X86=0
ASMFLAGS += -DARCH_ARM=$(OPTIM) -P../../../utils/config.asm
endif

ifeq ($(TARGET_ARCH_ABI),x86_64)
ASM_DIR = x86
CFLAGS += -march=x86-64 -m64 -msse -msse2 -msse3 -msse4.1
CFLAGS += -D_REENTRANT
ASMFLAGS += -DARCH_X86_64=1
endif

ifeq ($(TARGET_ARCH_ABI),x86)
ASM_DIR = x86
CFLAGS += -march=i686 -m32 -msse -msse2 -msse3 -msse4.1
CFLAGS += -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 -DARCH_ARM=0 -DARCH_AARCH64=0
ASMFLAGS += -DARCH_X86=1 -DARCH_X86_32=1 -DARCH_X86_64=0 -DARCH_ARM=0 -DARCH_AARCH64=0 -P../../../utils/config.asm
endif

#设置编译参数
LOCAL_CFLAGS := $(CFLAGS)
LOCAL_CPPFLAGS := $(CFLAGS)
LOCAL_ASMFLAGS := $(ASMFLAGS)

include $(LOCAL_PATH)/common.mk

#配置编译静态库、动态库
ifeq ($(SHARED),1)
include $(BUILD_SHARED_LIBRARY)
else
include $(BUILD_STATIC_LIBRARY)
endif

