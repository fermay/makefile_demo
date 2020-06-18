#检测系统
OS = $(shell uname)

#设置是否调试
ifeq ($(DEBUG), 0)
	DEBUG_FLAGS := -O3
else
	DEBUG_FLAGS := -g
endif

#########################################
############Windows系统 ###################
ifeq ($(findstring MINGW, $(OS)), MINGW)
	CC	:= c99wrap cl
	CPP	:= c99wrap cl
	AR	:= lib
	LD	:= c99wrap link
	RC	:= rc
	ASM	:= yasm
	
ifeq ($(platform), x86_32)
	ARCH_DEF	:=
	OUT_DIR		:= ../../bin/x86
	EXTRA_CFLAGS	:= -DWIN32 
	EXTRA_ASMFLAGS	:= -f win32 -DARCH_X86_64=0 -DPREFIX  -DHAVE_MMX=1 -DARCH_X86=1
	EXTRA_RCFLAGS	:= -DWIN32
	ASM_DIR			:= x86
	ASM_SUFFIX		:= asm
endif

ifeq ($(platform), x86_64)
	ARCH_DEF	:=
	OUT_DIR		:= ../../bin/x86_64
	EXTRA_CFLAGS	:= -DWIN64
	EXTRA_ASMFLAGS	:= -f x64  -DARCH_X86_64=1 -DHAVE_MMX=1 -DARCH_X86=1
	EXTRA_RCFLAGS	:= -DWIN64
	ASM_DIR			:= x86
	ASM_SUFFIX		:= asm
endif

endif ##MINGW

#########################################
############linux系统 ###################
ifeq ($(findstring Linux, $(OS)), Linux)
	CROSS ?= 
	CC	:= $(CROSS)gcc -fPIC -DPIC
	CPP	:= $(CROSS)g++ -fPIC -DPIC
	LD	:= $(CROSS)ld
	AR	:= $(CROSS)ar
	ASM	:=	yasm -DPIC
	
###ARM32架构	
ifeq ($(platform), arm32)
	ARCH_DEF	:= -DARCH_ARM=1 -DHAVE_NEON=1
	EXTRA_CFLAGS := -march=armv7-a -marm $(ARCH_DEF)
	EXTRA_LFLAGS := -march=armv7-a -marm 
	EXTRA_AFLAGS := -march=armv7-a $(ARCH_DEF)
	OUT_DIR		:= ../../bin/arm32
	ASM_DIR		:= arm
	ASM_SUFFIX	:= S
endif

###ARM64架构	
ifeq ($(platform), arm64)
	ARCH_DEF	:=
	EXTRA_CFLAGS := -march=armv8-a $(ARCH_DEF)
	EXTRA_LFLAGS := -march=armv8-a  
	EXTRA_AFLAGS := -march=armv8-a $(ARCH_DEF)
	OUT_DIR		:= ../../bin/aarch64
	ASM_DIR		:= aarch64
	ASM_SUFFIX	:= S
endif

###X86_32架构	
ifeq ($(platform), x86_32)
	ARCH_DEF	:=-DARCH_X86_64=0
	EXTRA_CFLAGS := -m32 $(ARCH_DEF)
	EXTRA_LFLAGS := -m32 -shared
	EXTRA_AFLAGS :=  -f elf32 $(ARCH_DEF)  
	OUT_DIR		:= ../../bin/x86
	ASM_DIR		:= x86
	ASM_SUFFIX	:= asm
endif


###X86_64架构	
ifeq ($(platform), x86_64)
	ARCH_DEF	:= -DARCH_X86_64=1
	EXTRA_CFLAGS := -m64 $(ARCH_DEF)
	EXTRA_LFLAGS := -m64 -shared -Wl,-Bsymbolic
	EXTRA_AFLAGS := -f elf64 $(ARCH_DEF)
	OUT_DIR		:= ../../bin/x86_64
	ASM_DIR		:= x86
	ASM_SUFFIX	:= asm
endif

endif

#########################################
############MAC/IOS系统 ###################
ifeq ($(findstring Darwin, $(OS)), Darwin) 

###MAC平台
ifeq ($(target_plat), mac)
	CROSS ?= 
	CC	:= $(CROSS)gcc -fPIC -DPIC
	CPP	:= $(CROSS)g++ -fPIC -DPIC
	AR	:= $(CROSS)ar
	ASM	:=	yasm -DPIC
	
##X86_32架构
ifeq ($(platform), x86_32)
	ARCH_DEF :=
	EXTRA_CFLAGS	:= -m32
	EXTRA_LFLAGS	:= -m32 -dynamiclib -Wl, -dynamic -Wl, -read_only_relocs, suppress
	EXTRA_AFLAGS	:= -f macho32 -m x86
	OUT_DIR			:= ../../bin/mac32
	ASM_DIR			:= x86
	ASM_SUFFIX		:= asm
endif

##X86_64架构
ifeq ($(platform), x86_64)
	ARCH_DEF :=
	EXTRA_CFLAGS	:= -m64
	EXTRA_LFLAGS	:= -m64 -dynamiclib -Wl, -dynamic
	EXTRA_AFLAGS	:= -f macho64 -m amd64
	OUT_DIR			:= ../../bin/mac64
	ASM_DIR			:= x86
	ASM_SUFFIX		:= asm
endif

endif

###IOS平台
ifeq ($(target_plat), ios)
	CROSS := iphone
ifeq ($(platform), ios32)
	CC	:= xcrun -sdk $(CROSS)os clang
	CPP	:= g++
	AR	:= ar
	ASM	:= gas-preprocessor.pl -arch arm -as-type apple-clang --$(CC)
	
	ARCH_DEF	:=
	EXTRA_CFLAGS := -arch armv7 -mios-version-min=6.0
	EXTRA_LFLAGS := -arch armv7 -mios-version-min=6.0
	EXTRA_AFLAGS := -arch armv7 -mios-version-min=6.0
	OUT_DIR		:= ../../bin/ios32
	ASM_DIR			:= arm
	ASM_SUFFIX		:= S
endif

ifeq ($(platform), ios64)
	CC	:= xcrun -sdk $(CROSS)os clang
	CPP := g++
	AR	:= ar
	ASM	:= gas-preprocessor.pl -arch aarch64 -as-type apple-clang --$(CC)
	
	ARCH_DEF	:=
	EXTRA_CFLAGS := -arch arm64 -mios-version-min=6.0
	EXTRA_LFLAGS := -arch arm64 -mios-version-min=6.0
	EXTRA_AFLAGS := -arch arm64 -mios-version-min=6.0
	OUT_DIR		:= ../../bin/ios64
	ASM_DIR			:= aarch64
	ASM_SUFFIX		:= S
endif 

ifeq ($(platform), ios_sim32)
	CC	:= xcrun -sdk $(CROSS)simulators clang
	CPP	:= g++
	AR	:= ar
	ASM	:= yasm
	
	ARCH_DEF	:=
	EXTRA_CFLAGS := -arch i386 -mios-simulator-version-min=6.0
	EXTRA_LFLAGS := -arch i386 -mios-simulator-version-min=6.0 -Wl, -Bsymbolic-functions -read_only_relocs suppress
	EXTRA_AFLAGS := -f macho32 -m x86
	OUT_DIR		:= ../../bin/ios_sim
	ASM_DIR			:= x86
	ASM_SUFFIX		:= asm
endif 

ifeq ($(platform), ios_sim64)
	CC	:= xcrun -sdk $(CROSS)simulators clang
	CPP	:= g++
	AR	:= ar
	ASM	:= yasm
	
	ARCH_DEF	:=
	EXTRA_CFLAGS := -arch x86_64 -mios-simulator-version-min=6.0
	EXTRA_LFLAGS := -arch x86_64 -mios-simulator-version-min=6.0
	EXTRA_AFLAGS := -f macho64 -m amd64
	OUT_DIR		:= ../../bin/ios_sim
	ASM_DIR			:= x86
	ASM_SUFFIX		:= asm
endif 

endif ##ifeq ($(target_plat), ios)

endif