LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := demo

LOCAL_C_INCLUDES :=  	$(LOCAL_PATH)/../../../demo/	\
						$(LOCAL_PATH)/../../../include/


#设置公用编译参数
CFLAGS := -Wall
CFLAGS += -fPIC
CFLAGS += -std=c99
CFLAGS += $(GDBEN)

#特定架构编译参数
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
INCLUDEASM = aarch64
CFLAGS += -march=armv8-a
endif
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
INCLUDEASM = arm
CFLAGS += -march=armv7-a -mfpu=neon -marm
endif

ifeq ($(TARGET_ARCH_ABI),x86_64)
INCLUDEASM = x86
CFLAGS += -march=x86-64 -m64 -msse -msse2 -msse3 -msse4.1
endif

ifeq ($(TARGET_ARCH_ABI),x86)
INCLUDEASM = x86
CFLAGS += -march=i686 -m32 -msse -msse2 -msse3 -msse4.1
endif

#设置编译参数
LOCAL_CFLAGS := $(CFLAGS)
LOCAL_CPPFLAGS := $(CFLAGS)	
LOCAL_LDFLAGS := $(LOCAL_PATH)/../out/$(TARGET_ARCH_ABI)/libxTest.a
#LOCAL_STATIC_LIBRARIES := $(LOCAL_PATH)/../out/$(TARGET_ARCH_ABI)/libxTest.a

#设置demo源文件
SRC_DIR =$(LOCAL_PATH)/../../../demo
DEMO_SRCS := $(SRC_DIR)/demo.c
DEMO_SRCS += $(SRC_DIR)/os_time.c

LOCAL_SRC_FILES := $(DEMO_SRCS)

include $(BUILD_EXECUTABLE) 

