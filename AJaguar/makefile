# Makefile for the SDL 1.2 Atari Jaguar library

# Parameters list
#
# $2: mode is used
# $1: cmd sets the command / order to be used


# Text/message colors
# Green (0;32)        : Compilation
# Brown/Orange (0;33) : Data & Source transformation
# Purple (0;35)       : Linking
# Cyan (00;36)        : Reporting
# Light Red (1;31)    : Remove/Delete data
# Light Green (1;32)  : Assembling
# Yellow (1;33)       : Updating
# Light Cyan (1;36)   : Config reading
# White (1;37)        : Creation directory
COLOR_ASSEMBLER = 01;32
COLOR_COMPILE   = 00;32
COLOR_LINKER    = 00;35
COLOR_MKDIR     = 01;37
COLOR_REPORTS	= 00;36
COLOR_REMOVE    = 01;31
COLOR_TRANSFORM = 00;33
COLOR_UPDATING  = 01;33
COLOR_CONFIG    = 01;36


# Check grep setup
DOT := $(shell command -v grep 2> /dev/null)
ifndef DOT
$(error No setup for grep)
endif


# Mode detection
#
ifndef mode
$(error mode is missing)
else
ifdef mode
ifneq ($(mode), Debug)
ifneq ($(mode), Release)
ifneq ($(mode), Profile)
ifneq ($(mode), Retail)
$(error mode is not recognised)
endif
endif
endif
endif
MODE = $(shell echo $(mode) | tr a-z A-Z)
else
$(error mode is missing; must be either Debug, Profile, Release or Retail)
endif
endif


# Configuration
#
# Compilation verbose
Q := @
#
# Include the tools executables and paths
include config.mk

# OpenGL support (TinyGL, no)
OPENGL_SELECT = no


# Directories
DIR = ./..
SRC = $(DIR)/src
DOCS = $(DIR)/docs
INCLUDE = $(DIR)/include
LIBCDIR = $(DIR)/AJaguar/$(mode)/lib
OBJC = $(LIBCDIR)/obj/$(FORMAT)/$(COMPILER_C)
OBJASM = $(LIBCDIR)/obj/$(FORMAT)
#
# Objects directories
ROOT_OBJC = $(OBJC)
AUDIO_OBJC = $(OBJC)/audio
CDROM_OBJC = $(OBJC)/cdrom
CPUINFO_OBJC = $(OBJC)/cpuinfo
EVENTS_OBJC = $(OBJC)/events
FILE_OBJC = $(OBJC)/file
JOYSTICK_OBJC = $(OBJC)/joystick
LOADSO_OBJC = $(OBJC)/loadso
MAIN_OBJC = $(OBJC)/main
STDLIB_OBJC = $(OBJC)/stdlib
THREAD_OBJC = $(OBJC)/thread
TIMER_OBJC = $(OBJC)/timer
VIDEO_OBJC = $(OBJC)/video
RUNTIME_OBJC = $(OBJC)
RUNTIME_OBJASM = $(OBJASM)
#
# Sources directories
ROOT_SRC = $(SRC)
AUDIO_SRC = $(SRC)/audio
CPUINFO_SRC = $(SRC)/cpuinfo
CDROM_SRC = $(SRC)/cdrom
EVENTS_SRC = $(SRC)/events
FILE_SRC = $(SRC)/file
JOYSTICK_SRC = $(SRC)/joystick
LOADSO_SRC = $(SRC)/loadso
MAIN_SRC = $(SRC)/main
STDLIB_SRC = $(SRC)/stdlib
THREAD_SRC = $(SRC)/thread
TIMER_SRC = $(SRC)/timer
VIDEO_SRC = $(SRC)/video
RUNTIME_SRC = $(DIR)/AJaguar/src/Runtime
#
# SDK directories
AJAGUARSDK = c:/SDK/AJaguar/OfficialJaguarKit/Include
ifneq ($(OPENGL_SELECT), no)
OPENGLSDK = C:/SDK/$(OPENGL_SELECT)/include
endif


# Version detection
VERMAJOR = $(strip $(shell command grep -oP -m -1 '(?<=#define SDL_MAJOR_VERSION).*' $(INCLUDE)/SDL_version.h))
VERMINOR = $(strip $(shell command grep -oP -m -1 '(?<=#define SDL_MINOR_VERSION).*' $(INCLUDE)/SDL_version.h))
VERPATCH = $(strip $(shell command grep -oP -m -1 '(?<=#define SDL_PATCHLEVEL).*' $(INCLUDE)/SDL_version.h))
VERSION = $(VERMAJOR).$(VERMINOR).$(VERPATCH)
ifeq ($(VERSION), "")
$(error No version found)
endif


# Compiler GCC information
ifeq ($(COMPILER_C_TYPE), gcc)
CFLAGS = -c -m68000 -Wall -Wextra -MD -MP -D$(MODE) -D__AJAGUAR__
CCINC = -IC:/Projects/Lib-M68K/include -I$(CCINC1) -I$(CCINC2) -I$(RUNTIME_SRC)
CCINC += -I$(INCLUDE) -I$(SRC)
ifneq ($(OPENGL_SELECT), no)
CFLAGS += -DSDL_VIDEO_OPENGL=1
CCINC += -I$(OPENGLSDK)
endif
# -IC:/SDK/zlib-1.2.5.win32/include
# -IC:/SDK/SDL_mixer-devel-1.2.12-VC/include
# -IC:/Projects/JaGL/include
CCOBJ = -o $@
ifeq ($(FORMAT), elf)
ifeq ($(mode), Debug)
CFLAGS += -g -O0 -gdwarf-2
# -fleading-underscore
else
ifeq ($(mode), Profile)
CFLAGS += -pg -g -O0 -DNDEBUG -gdwarf-2 -fstack-usage -DDEBUG
else
ifeq ($(mode), Release)
CFLAGS += -DNDEBUG -fomit-frame-pointer -Ofast
else
$(error mode is not recognised, must be either Debug, Release, Retail or - eventualy Profile)
endif
endif
endif
else
$(error FORMAT is not set or wrongly dispatched for $(COMPILER_SELECT))
endif 
#
# Compiler not recognised
else
$(error COMPILER_C_TYPE is not recognised)
endif


# Assembler VASM information
ifeq ($(ASM), vasm)
ifeq ($(VASM_SUPPORT), madmac)
AOPT = -quiet -m68000 -F$(FORMAT) -D$(MODE) -D$(ASM) -I$(AJAGUARSDK)
else
$(error $(ASM) must use the madmac format, please update the config.mk file in accordance)
endif
#
# Assembler not recognised
else
$(error ASM is not recognised)
endif


# Library information
AR_OPT = rcs
ARAN_OPT =
LIBMAINC = SDL_main-$(VERSION)_AJAG_$(mode)_$(COMPILER_SELECT).$(FORMAT).a
ifneq ($(OPENGL_SELECT), no)
LIBC = SDL-$(VERSION)_AJAG_$(OPENGL_SELECT)_$(mode)_$(COMPILER_SELECT).$(FORMAT).a
else
LIBC = SDL-$(VERSION)_AJAG_$(mode)_$(COMPILER_SELECT).$(FORMAT).a
endif


# Sources C dependence
SRC_C_DEPS	=	$(INCLUDE)\SDL_config.h


ROOT_OBJS		=	$(ROOT_OBJC)/SDL.o \
					$(ROOT_OBJC)/SDL_error.o \
					$(ROOT_OBJC)/SDL_fatal.o
#
ROOT_OBJS_d		=	$(ROOT_OBJC)/SDL.d \
					$(ROOT_OBJC)/SDL_error.d \
					$(ROOT_OBJC)/SDL_fatal.d
#
AUDIO_OBJS		=	$(AUDIO_OBJC)/SDL_audio.o \
					$(AUDIO_OBJC)/SDL_audiocvt.o \
					$(AUDIO_OBJC)/SDL_audiodev.o \
					$(AUDIO_OBJC)/SDL_ajaguaraudio.o \
					$(AUDIO_OBJC)/SDL_mixer.o \
					$(AUDIO_OBJC)/SDL_mixer_m68k.o \
					$(AUDIO_OBJC)/SDL_wave.o
#
AUDIO_OBJS_d	=	$(AUDIO_OBJC)/SDL_audio.d \
					$(AUDIO_OBJC)/SDL_audiocvt.d \
					$(AUDIO_OBJC)/SDL_audiodev.d \
					$(AUDIO_OBJC)/SDL_ajaguaraudio.d \
					$(AUDIO_OBJC)/SDL_mixer.d \
					$(AUDIO_OBJC)/SDL_mixer_m68k.d \
					$(AUDIO_OBJC)/SDL_wave.d
#
CDROM_OBJS		=	$(CDROM_OBJC)/SDL_cdrom.o \
					$(CDROM_OBJC)/SDL_syscdrom.o
#
CDROM_OBJS_d	=	$(CDROM_OBJC)/SDL_cdrom.d \
					$(CDROM_OBJC)/SDL_syscdrom.d
#
CPUINFO_OBJS	=	$(CPUINFO_OBJC)/SDL_cpuinfo.o
#
CPUINFO_OBJS_d	=	$(CPUINFO_OBJC)/SDL_cpuinfo.d
#
EVENTS_OBJS		=	$(EVENTS_OBJC)/SDL_active.o \
					$(EVENTS_OBJC)/SDL_events.o \
					$(EVENTS_OBJC)/SDL_expose.o \
					$(EVENTS_OBJC)/SDL_keyboard.o \
					$(EVENTS_OBJC)/SDL_mouse.o \
					$(EVENTS_OBJC)/SDL_quit.o \
					$(EVENTS_OBJC)/SDL_resize.o
#
EVENTS_OBJS_d	=	$(EVENTS_OBJC)/SDL_active.d \
					$(EVENTS_OBJC)/SDL_events.d \
					$(EVENTS_OBJC)/SDL_expose.d \
					$(EVENTS_OBJC)/SDL_keyboard.d \
					$(EVENTS_OBJC)/SDL_mouse.d \
					$(EVENTS_OBJC)/SDL_quit.d \
					$(EVENTS_OBJC)/SDL_resize.d
#
FILE_OBJS		=	$(FILE_OBJC)/SDL_rwops.o
#
FILE_OBJS_d		=	$(FILE_OBJC)/SDL_rwops.d
#
JOYSTICK_OBJS	=	$(JOYSTICK_OBJC)/SDL_joystick.o \
					$(JOYSTICK_OBJC)/SDL_sysjoystick.o
#
JOYSTICK_OBJS_d	=	$(JOYSTICK_OBJC)/SDL_joystick.d \
					$(JOYSTICK_OBJC)/SDL_sysjoystick.d
#
LOADSO_OBJS		=	$(LOADSO_OBJC)/SDL_sysloadso.o
#
LOADSO_OBJS_d	=	$(LOADSO_OBJC)/SDL_sysloadso.d
#
MAIN_OBJS		=	$(MAIN_OBJC)/SDL_ajaguar_main.o
#
MAIN_OBJS_d		=	$(MAIN_OBJC)/SDL_ajaguar_main.d
#
STDLIB_OBJS		=	$(STDLIB_OBJC)/SDL_getenv.o \
					$(STDLIB_OBJC)/SDL_iconv.o \
					$(STDLIB_OBJC)/SDL_malloc.o \
					$(STDLIB_OBJC)/SDL_qsort.o \
					$(STDLIB_OBJC)/SDL_stdlib.o \
					$(STDLIB_OBJC)/SDL_string.o
#
STDLIB_OBJS_d	=	$(STDLIB_OBJC)/SDL_getenv.d \
					$(STDLIB_OBJC)/SDL_iconv.d \
					$(STDLIB_OBJC)/SDL_malloc.d \
					$(STDLIB_OBJC)/SDL_qsort.d \
					$(STDLIB_OBJC)/SDL_stdlib.d \
					$(STDLIB_OBJC)/SDL_string.d
#
THREAD_OBJS		=	$(THREAD_OBJC)/SDL_syscond.o \
					$(THREAD_OBJC)/SDL_sysmutex.o \
					$(THREAD_OBJC)/SDL_syssem.o \
					$(THREAD_OBJC)/SDL_systhread.o \
					$(THREAD_OBJC)/SDL_thread.o
#
THREAD_OBJS_d	=	$(THREAD_OBJC)/SDL_syscond.d \
					$(THREAD_OBJC)/SDL_sysmutex.d \
					$(THREAD_OBJC)/SDL_syssem.d \
					$(THREAD_OBJC)/SDL_systhread.d \
					$(THREAD_OBJC)/SDL_thread.d
#
TIMER_OBJS		=	$(TIMER_OBJC)/SDL_timer.o \
					$(TIMER_OBJC)/SDL_systimer.o
#
TIMER_OBJS_d	=	$(TIMER_OBJC)/SDL_timer.d \
					$(TIMER_OBJC)/SDL_systimer.d
#
VIDEO_OBJS		=	$(VIDEO_OBJC)/SDL_blit.o \
					$(VIDEO_OBJC)/SDL_blit_0.o \
					$(VIDEO_OBJC)/SDL_blit_1.o \
					$(VIDEO_OBJC)/SDL_blit_A.o \
					$(VIDEO_OBJC)/SDL_blit_N.o \
					$(VIDEO_OBJC)/SDL_bmp.o \
					$(VIDEO_OBJC)/SDL_cursor.o \
					$(VIDEO_OBJC)/SDL_gamma.o \
					$(VIDEO_OBJC)/SDL_ajaguarevents.o \
					$(VIDEO_OBJC)/SDL_ajaguarmouse.o \
					$(VIDEO_OBJC)/SDL_ajaguarvideo.o \
					$(VIDEO_OBJC)/SDL_pixels.o \
					$(VIDEO_OBJC)/SDL_RLEaccel.o \
					$(VIDEO_OBJC)/SDL_stretch.o \
					$(VIDEO_OBJC)/SDL_surface.o \
					$(VIDEO_OBJC)/SDL_video.o \
					$(VIDEO_OBJC)/SDL_yuv.o \
					$(VIDEO_OBJC)/SDL_yuv_sw.o
#
VIDEO_OBJS_d	=	$(VIDEO_OBJC)/SDL_blit.d \
					$(VIDEO_OBJC)/SDL_blit_0.d \
					$(VIDEO_OBJC)/SDL_blit_1.d \
					$(VIDEO_OBJC)/SDL_blit_A.d \
					$(VIDEO_OBJC)/SDL_blit_N.d \
					$(VIDEO_OBJC)/SDL_bmp.d \
					$(VIDEO_OBJC)/SDL_cursor.d \
					$(VIDEO_OBJC)/SDL_gamma.d \
					$(VIDEO_OBJC)/SDL_ajaguarevents.d \
					$(VIDEO_OBJC)/SDL_ajaguarmouse.d \
					$(VIDEO_OBJC)/SDL_ajaguarvideo.d \
					$(VIDEO_OBJC)/SDL_pixels.d \
					$(VIDEO_OBJC)/SDL_RLEaccel.d \
					$(VIDEO_OBJC)/SDL_stretch.d \
					$(VIDEO_OBJC)/SDL_surface.d \
					$(VIDEO_OBJC)/SDL_video.d \
					$(VIDEO_OBJC)/SDL_yuv.d \
					$(VIDEO_OBJC)/SDL_yuv_sw.d
#
RUNTIME_OBJS	=	$(RUNTIME_OBJASM)/IRQHandler.o \
					$(RUNTIME_OBJASM)/joypad.o \
					$(RUNTIME_OBJASM)/video_320x240x8.o
#
RUNTIME_OBJS_d	=	$(RUNTIME_OBJASM)/IRQHandler.d \
					$(RUNTIME_OBJASM)/joypad.d \
					$(RUNTIME_OBJASM)/video_320x240x8.d


# SDL library
LIB_OBJS	=	$(ROOT_OBJS) \
				$(AUDIO_OBJS) \
				$(CDROM_OBJS) \
				$(CPUINFO_OBJS) \
				$(EVENTS_OBJS) \
				$(FILE_OBJS) \
				$(JOYSTICK_OBJS) \
				$(LOADSO_OBJS) \
				$(STDLIB_OBJS) \
				$(THREAD_OBJS) \
				$(TIMER_OBJS) \
				$(VIDEO_OBJS) \
				$(RUNTIME_OBJS)
#
# SDL_main library
LIBMAIN_OBJS	=	$(MAIN_OBJS)


# Check directory existence
#
ifeq ("$(wildcard $(ROOT_OBJC))","")
ifneq ($(cmd), makedirs)
$(error the directories to create $(LIBC) don't exist, please use makedirs command)
endif
endif


all:	compile \
		library
#
rebuild:	clean \
			all
#
compile:	compile_audio \
			compile_cdrom \
			compile_cpuinfo \
			compile_events \
			compile_file \
			compile_joystick \
			compile_loadso \
			compile_main \
			compile_root \
			compile_runtime \
			compile_stdlib \
			compile_thread \
			compile_timer \
			compile_video
#
library:	$(LIBCDIR)/$(LIBMAINC) \
			$(LIBCDIR)/$(LIBC)

# Project clean-up
#
clean:	clean_objs \
		clean_d \
		clean_libs
#
# Delete the dependence files
clean_d:
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the dependence files...\033[00m"	
	$(Q)rm -f -v $(ROOT_OBJC)/*.d
	$(Q)rm -f -v $(AUDIO_OBJC)/*.d
	$(Q)rm -f -v $(CDROM_OBJC)/*.d
	$(Q)rm -f -v $(CPUINFO_OBJC)/*.d
	$(Q)rm -f -v $(EVENTS_OBJC)/*.d
	$(Q)rm -f -v $(FILE_OBJC)/*.d
	$(Q)rm -f -v $(JOYSTICK_OBJC)/*.d
	$(Q)rm -f -v $(LOADSO_OBJC)/*.d
	$(Q)rm -f -v $(MAIN_OBJC)/*.d
	$(Q)rm -f -v $(STDLIB_OBJC)/*.d
	$(Q)rm -f -v $(THREAD_OBJC)/*.d
	$(Q)rm -f -v $(TIMER_OBJC)/*.d
	$(Q)rm -f -v $(VIDEO_OBJC)/*.d
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the Runtime dependence files...\033[00m"	
	$(Q)rm -f -v $(RUNTIME_OBJC)/*.d
	$(Q)rm -f -v $(RUNTIME_OBJASM)/*.d
#
# Delete the object files	
clean_objs:
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the obj files...\033[00m"	
	$(Q)rm -f -v $(ROOT_OBJC)/*.o
	$(Q)rm -f -v $(AUDIO_OBJC)/*.o
	$(Q)rm -f -v $(CDROM_OBJC)/*.o
	$(Q)rm -f -v $(CPUINFO_OBJC)/*.o
	$(Q)rm -f -v $(EVENTS_OBJC)/*.o
	$(Q)rm -f -v $(FILE_OBJC)/*.o
	$(Q)rm -f -v $(JOYSTICK_OBJC)/*.o
	$(Q)rm -f -v $(LOADSO_OBJC)/*.o
	$(Q)rm -f -v $(MAIN_OBJC)/*.o
	$(Q)rm -f -v $(STDLIB_OBJC)/*.o
	$(Q)rm -f -v $(THREAD_OBJC)/*.o
	$(Q)rm -f -v $(TIMER_OBJC)/*.o
	$(Q)rm -f -v $(VIDEO_OBJC)/*.o
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the Runtime obj files...\033[00m"	
	$(Q)rm -f -v $(RUNTIME_OBJC)/*.o
	$(Q)rm -f -v $(RUNTIME_OBJASM)/*.o
#
# Delete the libraries files
clean_libs:
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the libraries files...\033[00m"	
	$(Q)rm -f -v $(LIBCDIR)/$(LIBC)
	$(Q)rm -f -v $(LIBCDIR)/$(LIBMAINC)


# Root
compile_root:	$(ROOT_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(ROOT_OBJC)/*.d)", "")
include	$(ROOT_OBJS_d)
endif
#
$(ROOT_OBJC)/SDL.d:
$(ROOT_OBJC)/SDL.o:	$(ROOT_SRC)/SDL.c $(ROOT_OBJC)/SDL.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the root...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(ROOT_OBJC)/SDL_error.d:
$(ROOT_OBJC)/SDL_error.o:	$(ROOT_SRC)/SDL_error.c $(ROOT_OBJC)/SDL_error.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the root...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(ROOT_OBJC)/SDL_fatal.d:
$(ROOT_OBJC)/SDL_fatal.o:	$(ROOT_SRC)/SDL_fatal.c $(ROOT_OBJC)/SDL_fatal.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the root...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Audio
compile_audio:	$(AUDIO_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(AUDIO_OBJC)/*.d)", "")
include	$(AUDIO_OBJS_d)
endif
#
$(AUDIO_OBJC)/SDL_audio.d:
$(AUDIO_OBJC)/SDL_audio.o:	$(AUDIO_SRC)/SDL_audio.c $(AUDIO_OBJC)/SDL_audio.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the audio...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(AUDIO_OBJC)/SDL_audiocvt.d:
$(AUDIO_OBJC)/SDL_audiocvt.o:	$(AUDIO_SRC)/SDL_audiocvt.c $(AUDIO_OBJC)/SDL_audiocvt.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the audio...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(AUDIO_OBJC)/SDL_audiodev.d:
$(AUDIO_OBJC)/SDL_audiodev.o:	$(AUDIO_SRC)/SDL_audiodev.c $(AUDIO_OBJC)/SDL_audiodev.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the audio...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(AUDIO_OBJC)/SDL_ajaguaraudio.d:
$(AUDIO_OBJC)/SDL_ajaguaraudio.o:	$(AUDIO_SRC)/ajaguar/SDL_ajaguaraudio.c $(AUDIO_OBJC)/SDL_ajaguaraudio.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the audio...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(AUDIO_OBJC)/SDL_mixer.d:
$(AUDIO_OBJC)/SDL_mixer.o:	$(AUDIO_SRC)/SDL_mixer.c $(AUDIO_OBJC)/SDL_mixer.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the audio...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(AUDIO_OBJC)/SDL_mixer_m68k.d:
$(AUDIO_OBJC)/SDL_mixer_m68k.o:	$(AUDIO_SRC)/SDL_mixer_m68k.c $(AUDIO_OBJC)/SDL_mixer_m68k.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the audio...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(AUDIO_OBJC)/SDL_wave.d:
$(AUDIO_OBJC)/SDL_wave.o:	$(AUDIO_SRC)/SDL_wave.c $(AUDIO_OBJC)/SDL_wave.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the audio...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# CDROM
compile_cdrom:		$(CDROM_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(CDROM_OBJC)/*.d)", "")
include	$(CDROM_OBJS_d)
endif
#
$(CDROM_OBJC)/SDL_cdrom.d:
$(CDROM_OBJC)/SDL_cdrom.o:	$(CDROM_SRC)/SDL_cdrom.c $(CDROM_OBJC)/SDL_cdrom.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the CD-Rom...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(CDROM_OBJC)/SDL_syscdrom.d:
$(CDROM_OBJC)/SDL_syscdrom.o:	$(CDROM_SRC)/ajaguar/SDL_syscdrom.c $(CDROM_OBJC)/SDL_syscdrom.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the CD-Rom...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# CPU
compile_cpuinfo:	$(CPUINFO_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(CPUINFO_OBJC)/*.d)", "")
include	$(CPUINFO_OBJS_d)
endif
#
$(CPUINFO_OBJC)/SDL_cpuinfo.d:
$(CPUINFO_OBJC)/SDL_cpuinfo.o:	$(CPUINFO_SRC)/SDL_cpuinfo.c $(CPUINFO_OBJC)/SDL_cpuinfo.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the CPU...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Events
compile_events:		$(EVENTS_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(EVENTS_OBJC)/*.d)", "")
include	$(EVENTS_OBJS_d)
endif
#
$(EVENTS_OBJC)/SDL_active.d:
$(EVENTS_OBJC)/SDL_active.o:	$(EVENTS_SRC)/SDL_active.c $(EVENTS_OBJC)/SDL_active.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the events...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(EVENTS_OBJC)/SDL_events.d:
$(EVENTS_OBJC)/SDL_events.o:	$(EVENTS_SRC)/SDL_events.c $(EVENTS_OBJC)/SDL_events.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the events...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(EVENTS_OBJC)/SDL_expose.d:
$(EVENTS_OBJC)/SDL_expose.o:	$(EVENTS_SRC)/SDL_expose.c $(EVENTS_OBJC)/SDL_expose.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the events...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(EVENTS_OBJC)/SDL_keyboard.d:
$(EVENTS_OBJC)/SDL_keyboard.o:	$(EVENTS_SRC)/SDL_keyboard.c $(EVENTS_OBJC)/SDL_keyboard.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the events...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(EVENTS_OBJC)/SDL_mouse.d:
$(EVENTS_OBJC)/SDL_mouse.o:	$(EVENTS_SRC)/SDL_mouse.c $(EVENTS_OBJC)/SDL_mouse.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the events...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(EVENTS_OBJC)/SDL_quit.d:
$(EVENTS_OBJC)/SDL_quit.o:	$(EVENTS_SRC)/SDL_quit.c $(EVENTS_OBJC)/SDL_quit.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the events...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(EVENTS_OBJC)/SDL_resize.d:
$(EVENTS_OBJC)/SDL_resize.o:	$(EVENTS_SRC)/SDL_resize.c $(EVENTS_OBJC)/SDL_resize.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the events...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# File
compile_file:		$(FILE_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(FILE_OBJC)/*.d)", "")
include	$(FILE_OBJS_d)
endif
#
$(FILE_OBJC)/SDL_rwops.d:
$(FILE_OBJC)/SDL_rwops.o:	$(FILE_SRC)/SDL_rwops.c $(FILE_OBJC)/SDL_rwops.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the file...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Joystick
compile_joystick:	$(JOYSTICK_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(JOYSTICK_OBJC)/*.d)", "")
include	$(JOYSTICK_OBJS_d)
endif
#
$(JOYSTICK_OBJC)/SDL_joystick.d:
$(JOYSTICK_OBJC)/SDL_joystick.o:	$(JOYSTICK_SRC)/SDL_joystick.c $(JOYSTICK_OBJC)/SDL_joystick.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the joystick...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(JOYSTICK_OBJC)/SDL_sysjoystick.d:
$(JOYSTICK_OBJC)/SDL_sysjoystick.o:	$(JOYSTICK_SRC)/ajaguar/SDL_sysjoystick.c $(JOYSTICK_OBJC)/SDL_sysjoystick.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the joystick...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Loadso
compile_loadso:		$(LOADSO_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(LOADSO_OBJC)/*.d)", "")
include	$(LOADSO_OBJS_d)
endif
#
$(LOADSO_OBJC)/SDL_sysloadso.d:
$(LOADSO_OBJC)/SDL_sysloadso.o:	$(LOADSO_SRC)/ajaguar/SDL_sysloadso.c $(LOADSO_OBJC)/SDL_sysloadso.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the loadso...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Main
compile_main:		$(MAIN_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(MAIN_OBJC)/*.d)", "")
include	$(MAIN_OBJS_d)
endif
#
$(MAIN_OBJC)/SDL_ajaguar_main.d:
$(MAIN_OBJC)/SDL_ajaguar_main.o:	$(MAIN_SRC)/ajaguar/SDL_ajaguar_main.c $(MAIN_OBJC)/SDL_ajaguar_main.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the Atari Jaguar's main...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Stdlib
compile_stdlib:		$(STDLIB_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(STDLIB_OBJC)/*.d)", "")
include	$(STDLIB_OBJS_d)
endif
#
$(STDLIB_OBJC)/SDL_getenv.d:
$(STDLIB_OBJC)/SDL_getenv.o:	$(STDLIB_SRC)/SDL_getenv.c $(STDLIB_OBJC)/SDL_getenv.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the stdlib...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(STDLIB_OBJC)/SDL_iconv.d:
$(STDLIB_OBJC)/SDL_iconv.o:	$(STDLIB_SRC)/SDL_iconv.c $(STDLIB_OBJC)/SDL_iconv.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the stdlib...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(STDLIB_OBJC)/SDL_malloc.d:
$(STDLIB_OBJC)/SDL_malloc.o:	$(STDLIB_SRC)/SDL_malloc.c $(STDLIB_OBJC)/SDL_malloc.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the stdlib...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(STDLIB_OBJC)/SDL_qsort.d:
$(STDLIB_OBJC)/SDL_qsort.o:	$(STDLIB_SRC)/SDL_qsort.c $(STDLIB_OBJC)/SDL_qsort.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the stdlib...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(STDLIB_OBJC)/SDL_stdlib.d:
$(STDLIB_OBJC)/SDL_stdlib.o:	$(STDLIB_SRC)/SDL_stdlib.c $(STDLIB_OBJC)/SDL_stdlib.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the stdlib...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(STDLIB_OBJC)/SDL_string.d:
$(STDLIB_OBJC)/SDL_string.o:	$(STDLIB_SRC)/SDL_string.c $(STDLIB_OBJC)/SDL_string.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the stdlib...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Timer
compile_timer:		$(TIMER_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(TIMER_OBJC))/*.d", "")
include	$(TIMER_OBJS_d)
endif
#
$(TIMER_OBJC)/SDL_timer.d:
$(TIMER_OBJC)/SDL_timer.o:	$(TIMER_SRC)/SDL_timer.c $(TIMER_OBJC)/SDL_timer.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the timer...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(TIMER_OBJC)/SDL_systimer.d:
$(TIMER_OBJC)/SDL_systimer.o:	$(TIMER_SRC)/ajaguar/SDL_systimer.c $(TIMER_OBJC)/SDL_systimer.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the timer...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Thread
compile_thread:		$(THREAD_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(THREAD_OBJC)/*.d)", "")
include	$(THREAD_OBJS_d)
endif
#
$(THREAD_OBJC)/SDL_syscond.d:
$(THREAD_OBJC)/SDL_syscond.o:	$(THREAD_SRC)/ajaguar/SDL_syscond.c $(THREAD_OBJC)/SDL_syscond.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the thread...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(THREAD_OBJC)/SDL_sysmutex.d:
$(THREAD_OBJC)/SDL_sysmutex.o:	$(THREAD_SRC)/ajaguar/SDL_sysmutex.c $(THREAD_OBJC)/SDL_sysmutex.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the thread...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(THREAD_OBJC)/SDL_syssem.d:
$(THREAD_OBJC)/SDL_syssem.o:	$(THREAD_SRC)/ajaguar/SDL_syssem.c $(THREAD_OBJC)/SDL_syssem.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the thread...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(THREAD_OBJC)/SDL_systhread.d:
$(THREAD_OBJC)/SDL_systhread.o:	$(THREAD_SRC)/ajaguar/SDL_systhread.c $(THREAD_OBJC)/SDL_systhread.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the thread...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(THREAD_OBJC)/SDL_thread.d:
$(THREAD_OBJC)/SDL_thread.o:	$(THREAD_SRC)/SDL_thread.c $(THREAD_OBJC)/SDL_thread.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the thread...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Video
compile_video:		$(VIDEO_OBJS)
#
# Include the dependence file
ifeq ("$(wildcard $(VIDEO_OBJC)/*.d)", "")
include	$(VIDEO_OBJS_d)
endif
#
$(VIDEO_OBJC)/SDL_ajaguarevents.d:
$(VIDEO_OBJC)/SDL_ajaguarevents.o:	$(VIDEO_SRC)/ajaguar/SDL_ajaguarevents.c $(VIDEO_OBJC)/SDL_ajaguarevents.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_ajaguarmouse.d:
$(VIDEO_OBJC)/SDL_ajaguarmouse.o:	$(VIDEO_SRC)/ajaguar/SDL_ajaguarmouse.c $(VIDEO_OBJC)/SDL_ajaguarmouse.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_ajaguarvideo.d:
$(VIDEO_OBJC)/SDL_ajaguarvideo.o:	$(VIDEO_SRC)/ajaguar/SDL_ajaguarvideo.c $(VIDEO_OBJC)/SDL_ajaguarvideo.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_blit.d:
$(VIDEO_OBJC)/SDL_blit.o:	$(VIDEO_SRC)/SDL_blit.c $(VIDEO_OBJC)/SDL_blit.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_blit_0.d:
$(VIDEO_OBJC)/SDL_blit_0.o:	$(VIDEO_SRC)/SDL_blit_0.c $(VIDEO_OBJC)/SDL_blit_0.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_blit_1.d:
$(VIDEO_OBJC)/SDL_blit_1.o:	$(VIDEO_SRC)/SDL_blit_1.c $(VIDEO_OBJC)/SDL_blit_1.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_blit_A.d:
$(VIDEO_OBJC)/SDL_blit_A.o:	$(VIDEO_SRC)/SDL_blit_A.c $(VIDEO_OBJC)/SDL_blit_A.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_blit_N.d:
$(VIDEO_OBJC)/SDL_blit_N.o:	$(VIDEO_SRC)/SDL_blit_N.c $(VIDEO_OBJC)/SDL_blit_N.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_bmp.d:
$(VIDEO_OBJC)/SDL_bmp.o:	$(VIDEO_SRC)/SDL_bmp.c $(VIDEO_OBJC)/SDL_bmp.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_cursor.d:
$(VIDEO_OBJC)/SDL_cursor.o:	$(VIDEO_SRC)/SDL_cursor.c $(VIDEO_OBJC)/SDL_cursor.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_gamma.d:
$(VIDEO_OBJC)/SDL_gamma.o:	$(VIDEO_SRC)/SDL_gamma.c $(VIDEO_OBJC)/SDL_gamma.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_pixels.d:
$(VIDEO_OBJC)/SDL_pixels.o:	$(VIDEO_SRC)/SDL_pixels.c $(VIDEO_OBJC)/SDL_pixels.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_RLEaccel.d:
$(VIDEO_OBJC)/SDL_RLEaccel.o:	$(VIDEO_SRC)/SDL_RLEaccel.c $(VIDEO_OBJC)/SDL_RLEaccel.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_stretch.d:
$(VIDEO_OBJC)/SDL_stretch.o:	$(VIDEO_SRC)/SDL_stretch.c $(VIDEO_OBJC)/SDL_stretch.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_surface.d:
$(VIDEO_OBJC)/SDL_surface.o:	$(VIDEO_SRC)/SDL_surface.c $(VIDEO_OBJC)/SDL_surface.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_video.d:
$(VIDEO_OBJC)/SDL_video.o:	$(VIDEO_SRC)/SDL_video.c $(VIDEO_OBJC)/SDL_video.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_yuv.d:
$(VIDEO_OBJC)/SDL_yuv.o:	$(VIDEO_SRC)/SDL_yuv.c $(VIDEO_OBJC)/SDL_yuv.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(VIDEO_OBJC)/SDL_yuv_sw.d:
$(VIDEO_OBJC)/SDL_yuv_sw.o:	$(VIDEO_SRC)/SDL_yuv_sw.c $(VIDEO_OBJC)/SDL_yuv_sw.d $(SRC_C_DEPS)
	@echo -e "\033[01;33m***\033[00;32m Compiling $< for the video...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Runtime
compile_runtime:	$(RUNTIME_OBJS)
#
# Include the dependence file
#include	$(RUNTIME_OBJS_d)
#
#$(RUNTIME_OBJC)/crt_externs.o:	$(RUNTIME_SRC)/crt_externs.c $(SRC_C_DEPS)
#	$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
#$(RUNTIME_OBJC)/cmdlib.o:	$(RUNTIME_SRC)/cmdlib.c $(SRC_C_DEPS)
#	$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(RUNTIME_OBJS):	$(RUNTIME_OBJASM)/%.o:	$(RUNTIME_SRC)/%.s
	@echo -e "\033[01;33m***\033[$(COLOR_ASSEMBLER)m Assembling $< for Runtime...\033[00m"
	$(Q)$(ASMProg) $(AOPT) -o $@ $<


# Library creation
#
# SDL config
$(INCLUDE)\SDL_config.h:	$(INCLUDE)\SDL_config_ajaguar.h $(INCLUDE)\SDL_config.h.default
	@echo -e "\033[01;33m***\033[$(COLOR_UPDATING)m Copy updated config header file...\033[00m"
	$(Q)cp -u $(INCLUDE)\SDL_config.h.default $(INCLUDE)\SDL_config.h
#
# SDL
$(LIBCDIR)/$(LIBC):	$(LIB_OBJS)
	@echo -e "\033[01;33m***\033[00;32m Creating the SDL library for $(mode)...\033[00m"
	$(Q)$(ARProg) $(AR_OPT) $@ $(LIB_OBJS)
ifneq ("$(wildcard $(ARANProg))","")
	$(Q)$(ARANProg) $(ARAN_OPT) $@
endif
#	
# SDL_main
$(LIBCDIR)/$(LIBMAINC):	$(LIBMAIN_OBJS)
	@echo -e "\033[01;33m***\033[00;32m Creating the SDL_main library for $(mode)...\033[00m"
	$(Q)$(ARProg) $(AR_OPT) $@ $(LIBMAIN_OBJS)
ifneq ("$(wildcard $(ARANProg))","")
	$(Q)$(ARANProg) $(ARAN_OPT) $@
endif
		

makedirs:	mkdir_Runtime \
			mkdir_objs
#
# Create the Runtime's object and dependence files directories
mkdir_Runtime:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the dependencies and objs Runtime directory...\033[00m"
		$(Q)mkdir -p $(RUNTIME_OBJASM)
#
# Create the object and dependence files directories
mkdir_objs:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the libraries directories...\033[00m"
		$(Q)mkdir -p $(LIBCDIR)
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the dependencies and objs directories...\033[00m"
		$(Q)mkdir -p $(ROOT_OBJC)
		$(Q)mkdir -p $(AUDIO_OBJC)
		$(Q)mkdir -p $(CDROM_OBJC)
		$(Q)mkdir -p $(CPUINFO_OBJC)
		$(Q)mkdir -p $(EVENTS_OBJC)
		$(Q)mkdir -p $(FILE_OBJC)
		$(Q)mkdir -p $(JOYSTICK_OBJC)
		$(Q)mkdir -p $(LOADSO_OBJC)
		$(Q)mkdir -p $(MAIN_OBJC)
		$(Q)mkdir -p $(STDLIB_OBJC)
		$(Q)mkdir -p $(THREAD_OBJC)
		$(Q)mkdir -p $(TIMER_OBJC)
		$(Q)mkdir -p $(VIDEO_OBJC)
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the dependencies and objs Runtime directory...\033[00m"
		$(Q)mkdir -p $(RUNTIME_OBJC)
		$(Q)mkdir -p $(RUNTIME_OBJASM)

		
# Display configuration
#
config:	config_command \
		config_opengl \
		config_generic \
		config_compilation \
		config_assembling \
		config_libs \
		config_SDL \
		config_SDL_gl \
		config_SDL_main
#
# Display the compilation information
config_compilation:
	$(info ----------- Compiler)
	$(info Flags     : $(CFLAGS))
	$(info Headers   : $(CCINC))
#
# Display the assembling information
config_assembling:
	$(info ----------- Assembler)
	$(info Flags     : $(AOPT))
#
# Display the command from batch
config_command:
	$(info ----------- Command)
	$(info Mode      : $(mode))
#
# Display the command from OpenGL
config_opengl:
	$(info ----------- OpenGL)
	$(info OpenGL    : $(OPENGL_SELECT))
#
# Display generic information
config_generic:
	$(info ----------- Generic)
	$(info Format    : $(FORMAT))
	$(info Assembler : $(ASM))
	$(info Compiler  : $(COMPILER_C_TYPE) $(COMPILER_C_VERSION))
	$(info Library   : $(ARProg))
	$(info Library   : $(ARANProg))
#
# Display SDL specific information
config_SDL:
	$(info ----------- SDL)
#
# Display SDL_gl specific information
config_SDL_gl:
	$(info ----------- SDL_gl)	
#
# Display SDL_main specific information
config_SDL_main:
	$(info ----------- SDL_main)	
#
# Display libraries specific information
config_libs:
	$(info ----------- Libraries)
	$(info Version   : $(VERSION))
	$(info SDL       : $(LIBCDIR)/$(LIBC))
	$(info SDL_main  : $(LIBCDIR)/$(LIBMAINC))
