##主要指定源文件路径和头文件路径
SCRIPT_PATH := $(call my-dir)

SRC_DIR := $(SCRIPT_PATH)/../../../src

##头文件路径
LOCAL_C_INCLUDES := ./	\
			$(SRC_DIR)		\
			$(SRC_DIR)/../include \
			$(SRC_DIR)/$(INCLUDEASM)

##纯C文件路径
C_SRCS:= $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/$(INCLUDEASM)/*.c)
C_SRCS+= $(wildcard $(SRC_DIR)/../utils/*.c) $(wildcard $(SRC_DIR)/../utils/$(INCLUDEASM)/*.c)
#C_SRCS = C:\Users\fmy\Desktop\MakefileSample\src\h264pred.c 

##汇编文件路径
A_SRCS		:= 

ifeq ($(PURE_C),0)

#x86架构
ifeq ($(findstring x86,$(TARGET_ARCH_ABI)),x86)
IFLAGS += -I$(SRC_DIR)/x86
A_SRCS		+= $(wildcard $(SRC_DIR)/x86/*.asm) 
A_SRCS		+= $(wildcard $(SRC_DIR)/../utils/x86/*.asm) 
endif

#arm架构
ifeq ($(findstring armeabi-v7a, $(TARGET_ARCH_ABI)), armeabi-v7a)
IFLAGS += -I$(SRC_DIR)/arm
A_SRCS += $(wildcard $(SRC_DIR)/arm/*.S) 
A_SRCS		+= $(wildcard $(SRC_DIR)/../utils/arm/*.S) 
endif

endif

$(warning $(CFLAGS)) 

##设置汇编文件
LOCAL_SRC_FILES := $(A_SRCS) $(C_SRCS)

