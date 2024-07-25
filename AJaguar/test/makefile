# Makefile for the SDL 1.2 Atari Jaguar tests

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
include ../config.mk

# Executable selection (elf)
EXE_FORMAT = elf
#
# Libraries selection (lib-gcc, lib-m68k, none)
LIBC_SELECT = lib-m68k
LIBGCC_SELECT = lib-m68k
#
# Maths library selection (fdlibm, lib-gcc, lib-m68k, none)
MATHS_SELECT = fdlibm
#
# OpenGL support (TinyGL, no)
OPENGL_SELECT = no


# Directories
DIR = .
SRC = $(DIR)/../../test
INCLUDE = $(DIR)/../../include
LIBCDIR = $(DIR)/../$(mode)/lib
OBJC = $(DIR)/$(mode)/obj/$(FORMAT)/$(COMPILER_C)
CtoSDIR = $(DIR)/$(mode)/s/$(FORMAT)/$(COMPILER_C)
OBJASM = $(DIR)/$(mode)/obj/$(FORMAT)
EXEDIR = $(DIR)/$(mode)
FLSDIR = $(DIR)
ARGS = $(DIR)/src
DIRECTORY = $(DIR)/src
RUNTIME = $(DIR)/src/Runtime
#
ROOT_OBJC = $(OBJC)
ROOT_OBJASM = $(OBJASM)
#
ROOT_SRC = $(SRC)
#
# SDK directories
AJAGUARSDK = c:/SDK/AJaguar/OfficialJaguarKit/Include
ifneq ($(OPENGL_SELECT), no)
OPENGLSDK = C:/SDK/$(OPENGL_SELECT)/include
endif
ZLIBSDK = C:/SDK/zlib-1.2.5.win32/include
SDLMIXERSDK = C:/SDK/SDL_mixer-devel-1.2.12-VC/include


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
CCINC = -IC:/Projects/Lib-M68K/include -I$(CCINC1) -I$(CCINC2)
CCINC += -I$(ZLIBSDK)
CCINC += -I$(INCLUDE) -I$(SRC)
CCINC += -I$(SDLMIXERSDK)
ifneq ($(OPENGL_SELECT), no)
CCINC += -I$(OPENGLSDK)
endif
CCOBJ = -o $@
ifeq ($(FORMAT), elf)
ifeq ($(mode), Debug)
CFLAGS += -g -O0 -gdwarf-2
# -fleading-underscore
else
ifeq ($(mode), Profile)
CFLAGS += -pg -g -O0 -DNDEBUG -gdwarf-2 -fstack-usage -DDDEBUG
else
ifeq ($(mode), Release)
CFLAGS += -DNDEBUG -fomit-frame-pointer -Ofast
else
$(error mode is not recognised, must be either Debug, Release, Retail or - eventualy Profile)
endif
endif
endif
CFLAGS_S = -S
else
$(error FORMAT is not set or wrongly dispatched for $(COMPILER_SELECT))
endif 
#
# Compiler not recognised
else
$(error COMPILER_C_TYPE is not recognised)
endif


# Assembler Rmac information
ifeq ($(ASM), rmac)
AOPT = -m68000 +oall -d$(MODE) -dARGS -d$(shell echo $(LIBC_SELECT) | tr a-z A-Z | tr - _)
ifeq ($(FORMAT), elf)
AOPT += -fe
endif
# Assembler Vasm information
else
ifeq ($(ASM), vasm)
ifeq ($(VASM_SUPPORT), std)
AOPT = -quiet -m68000 -F$(FORMAT) -D$(MODE) -DARGS -D$(shell echo $(LIBC_SELECT) | tr a-z A-Z | tr - _)
ifeq ($(mode), Debug)
AOPT +=	-dwarf=3
# -DRELEASE=0 -DPROFILE=0
else
ifeq ($(mode), Profile)
AOPT +=	-dwarf=3
# -DRELEASE=0 -DDEBUG=0
else
ifeq ($(mode), Release)
#AOPT +=	-DPROFILE=0 -DDEBUG=0
endif
endif
endif
else
$(error $(ASM) must use the std format, please update the config.mk file in accordance)
endif
#
# Assembler not recognised
else
$(error ASM is not recognised)
endif
endif


# Linker information
#
## Vlink linker information
ifeq ($(LINKER_SELECT), vlink)
ifeq ($(EXE_FORMAT), elf)
LINKER_SCRIPT = -T $(FLSDIR)/AJagELFls
LINKER_OPTIONS = -b elf32jag -e _start -EB
else
$(error $(FORMAT) is not configured or supported by Vlink)
endif
endif


# Libraries information
#
LIB_SDL = $(LIBCDIR)/SDL-$(VERSION)_AJAG_$(mode)_$(COMPILER_SELECT).$(FORMAT).a
LIB_OS = $(mode)/libs/OSJag/OSJag-1.3_$(mode)_$(COMPILER_SELECT).$(FORMAT).a
DIR_LIBS =
#
# libgcc low-level runtime selection
ifeq ($(LIBGCC_SELECT), lib-m68k)
LIB_GCC = $(mode)/libs/libgcc-1.1_$(mode)-M68K.elf.a
else
ifeq ($(LIBGCC_SELECT), lib-gcc)
LIB_GCC = $(DIRLIBGCC)/libgcc.a
endif
endif
# libc Standard C library selection
ifeq ($(LIBC_SELECT), lib-m68k)
LIBC = $(mode)/libs/libc-1.2e_$(mode)_gcc-M68K.elf.a
else
ifeq ($(LIBC_SELECT), lib-gcc)
LIBC = $(DIRLIBC)/libc.a $(DIRLIBC)/libbcc.a
endif
endif
# Maths funtions library selection
ifneq ($(MATHS_SELECT), none)
ifeq ($(MATHS_SELECT), lib-gcc)
LIB_MATH = $(DIRLIBC)/libm.a
else
ifeq ($(MATHS_SELECT), lib-m68k)
LIB_MATH = $(mode)/libs/libm-1.0_$(mode)-M68K.elf.a
else
ifeq ($(MATHS_SELECT), fdlibm)
LIB_MATH = $(mode)/libs/fdlibm/fdlibm-5.2-2_IEEE_LIBM_$(mode)_m68K-$(COMPILER_SELECT).elf.a
endif
endif
endif
endif

# Check directory existence
#
ifeq ("$(wildcard $(ROOT_OBJC))","")
ifneq ($(cmd), makedirs)
ifneq ($(cmd), config)
$(error the directories to create the test applications do not exist, please use makedirs command)
endif
endif
endif


# Sources C dependence
SRC_C_DEPS	=	makefile build.bat $(INCLUDE)\SDL_config.h


ROOT_EXE	=	$(EXEDIR)/checkkeys_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/graywin_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/loopwave_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testalpha_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testbitmap_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testblitspeed_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testcdrom_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testcursor_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testdyngl_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testerror_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testfile_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testgamma_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testgl_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testhread_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testiconv_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testjoystick_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testkeys_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testloadso_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testlock_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testoverlay_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testoverlay2_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testpalette_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testplatform_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testsem_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testsprite_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testtimer_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testver_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testvidinfo_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testwin_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/testwm_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/threadwin_$(mode)_$(COMPILER_SELECT).$(FORMAT) \
				$(EXEDIR)/torturethread_$(mode)_$(COMPILER_SELECT).$(FORMAT)


RUNTIME_OBJS	=	$(ROOT_OBJASM)/crt0.o \
					$(ROOT_OBJASM)/environ.o
#
DIRECTORY_OBJS		=	$(ROOT_OBJASM)/checkkeys_OSJAG_Directory.o \
						$(ROOT_OBJASM)/graywin_OSJAG_Directory.o \
						$(ROOT_OBJASM)/loopwave_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testalpha_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testbitmap_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testblitspeed_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testcdrom_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testcursor_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testerror_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testfile_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testgamma_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testiconv_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testjoystick_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testkeys_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testloadso_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testlock_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testoverlay_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testoverlay2_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testpalette_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testsem_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testsprite_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testthread_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testtimer_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testver_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testvidinfo_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testwin_OSJAG_Directory.o \
						$(ROOT_OBJASM)/testwm_OSJAG_Directory.o \
						$(ROOT_OBJASM)/threadwin_OSJAG_Directory.o \
						$(ROOT_OBJASM)/torturethread_OSJAG_Directory.o
#
ARGS_OBJS		=	$(ROOT_OBJC)/checkkeys_args.o \
					$(ROOT_OBJC)/graywin_args.o \
					$(ROOT_OBJC)/testloadso_args.o \
					$(ROOT_OBJC)/loopwave_args.o \
					$(ROOT_OBJC)/testalpha_args.o \
					$(ROOT_OBJC)/testbitmap_args.o \
					$(ROOT_OBJC)/testblitspeed_args.o \
					$(ROOT_OBJC)/testcdrom_args.o \
					$(ROOT_OBJC)/testcursor_args.o \
					$(ROOT_OBJC)/testdyngl_args.o \
					$(ROOT_OBJC)/testerror_args.o \
					$(ROOT_OBJC)/testfile_args.o \
					$(ROOT_OBJC)/testgamma_args.o \
					$(ROOT_OBJC)/testgl_args.o \
					$(ROOT_OBJC)/testhread_args.o \
					$(ROOT_OBJC)/testiconv_args.o \
					$(ROOT_OBJC)/testjoystick_args.o \
					$(ROOT_OBJC)/testkeys_args.o \
					$(ROOT_OBJC)/testlock_args.o \
					$(ROOT_OBJC)/testoverlay_args.o \
					$(ROOT_OBJC)/testoverlay2_args.o \
					$(ROOT_OBJC)/testpalette_args.o \
					$(ROOT_OBJC)/testplatform_args.o \
					$(ROOT_OBJC)/testsem_args.o \
					$(ROOT_OBJC)/testsprite_args.o \
					$(ROOT_OBJC)/testtimer_args.o \
					$(ROOT_OBJC)/testver_args.o \
					$(ROOT_OBJC)/testvidinfo_args.o \
					$(ROOT_OBJC)/testwin_args.o \
					$(ROOT_OBJC)/testwm_args.o \
					$(ROOT_OBJC)/threadwin_args.o \
					$(ROOT_OBJC)/torturethread_args.o
#
ROOT_CtoS		=	$(CtoSDIR)/checkkeys.s \
					$(CtoSDIR)/graywin.s \
					$(CtoSDIR)/testplatform.s
#
ROOT_OBJS		=	$(ROOT_OBJC)/checkkeys.o \
					$(ROOT_OBJC)/graywin.o \
					$(ROOT_OBJC)/loopwave.o \
					$(ROOT_OBJC)/testalpha.o \
					$(ROOT_OBJC)/testbitmap.o \
					$(ROOT_OBJC)/testblitspeed.o \
					$(ROOT_OBJC)/testcdrom.o \
					$(ROOT_OBJC)/testcursor.o \
					$(ROOT_OBJC)/testdyngl.o \
					$(ROOT_OBJC)/testerror.o \
					$(ROOT_OBJC)/testfile.o \
					$(ROOT_OBJC)/testgamma.o \
					$(ROOT_OBJC)/testgl.o \
					$(ROOT_OBJC)/testhread.o \
					$(ROOT_OBJC)/testiconv.o \
					$(ROOT_OBJC)/testjoystick.o \
					$(ROOT_OBJC)/testkeys.o \
					$(ROOT_OBJC)/testloadso.o \
					$(ROOT_OBJC)/testlock.o \
					$(ROOT_OBJC)/testoverlay.o \
					$(ROOT_OBJC)/testoverlay2.o \
					$(ROOT_OBJC)/testpalette.o \
					$(ROOT_OBJC)/testplatform.o \
					$(ROOT_OBJC)/testsem.o \
					$(ROOT_OBJC)/testsprite.o \
					$(ROOT_OBJC)/testtimer.o \
					$(ROOT_OBJC)/testver.o \
					$(ROOT_OBJC)/testvidinfo.o \
					$(ROOT_OBJC)/testwin.o \
					$(ROOT_OBJC)/testwm.o \
					$(ROOT_OBJC)/threadwin.o \
					$(ROOT_OBJC)/torturethread.o


all:	compile \
		assemble \
		Runtime \
		link
#
rebuild:	clean \
			all
#
assemble:	Runtime \
			$(DIRECTORY_OBJS)
#	
Runtime:	$(RUNTIME_OBJS) \
#
compile:	$(ROOT_OBJS) \
			$(ARGS_OBJS) \
			$(ROOT_CtoS)
#
link:	$(ROOT_EXE)


# Project clean-up
#
clean:	clean_cobjs \
		clean_exes \
		clean_config \
		clean_CtoS
#
# Delete the config file
clean_config:
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Cleaning the configuration file...\033[00m"
	$(Q)rm -f -v $(INCLUDE)/SDL_config.h
#
# Delete the executable files
clean_exes:
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Cleaning the executable files...\033[00m"
	$(Q)rm -f -v $(EXEDIR)/*.$(FORMAT)
#
# Delete the asm files generated by compilation		
clean_CtoS:
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the asm sources generated from C compilation...\033[00m"	
	$(Q)rm -f -v $(CtoSDIR)/*.s
#
# Delete the object files	
clean_cobjs:
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Cleaning the obj files...\033[00m"
	$(Q)rm -f -v $(ROOT_OBJC)/*.o
	$(Q)rm -f -v $(ROOT_OBJASM)/*.o


# Test applications compilation
$(ROOT_OBJS): 	$(ROOT_OBJC)/%.o: $(ROOT_SRC)/%.c $(INCLUDE)\SDL_config.h
	@echo -e "\033[01;33m***\033[$(COLOR_COMPILE)m Compiling $< test...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<
$(ROOT_CtoS): 	$(CtoSDIR)/%.s: $(ROOT_SRC)/%.c $(INCLUDE)\SDL_config.h
	@echo -e "\033[01;33m***\033[$(COLOR_COMPILE)m Generating asm source code from $< test...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CFLAGS_S) $(CCINC) $(CCOBJ) $<

# Directory
$(DIRECTORY_OBJS): $(ROOT_OBJASM)/%.o: $(DIRECTORY)/%.asm
	@echo -e "\033[01;33m***\033[$(COLOR_ASSEMBLER)m Assembling $< for the files directory...\033[00m"
	$(Q)$(ASMProg) $(AOPT) -o $@ $<

# Args
$(ARGS_OBJS):	$(ROOT_OBJC)/%.o: $(ARGS)/%.c
	@echo -e "\033[01;33m***\033[$(COLOR_COMPILE)m Compiling $< for the arguments...\033[00m"
	$(Q)$(CCProg) $(CFLAGS) $(CCINC) $(CCOBJ) $<

# Runtime
$(RUNTIME_OBJS):	$(ROOT_OBJASM)/%.o:	$(RUNTIME)/%.s
	@echo -e "\033[01;33m***\033[$(COLOR_ASSEMBLER)m Assembling $< for the Runtime...\033[00m"
	$(Q)$(ASMProg) $(AOPT) -o $@ $<
#$(ROOT_OBJASM)/crt0.o:	$(RUNTIME)/crt0.s
#	@echo -e "\033[01;33m***\033[$(COLOR_ASSEMBLER)m Assembling $< for the Runtime...\033[00m"
#	$(Q)$(ASMProg) $(AOPT) -o $@ $<


# Test applications executable
#
$(EXEDIR)/checkkeys_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/checkkeys.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_OS) $(LIB_MATH) $(RUNTIME_OBJS) $(ROOT_OBJC)/checkkeys_args.o $(ROOT_OBJASM)/checkkeys_OSJAG_Directory.o
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $(LIB_OS) $< $(LIB_MATH) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/checkkeys_args.o $(ROOT_OBJASM)/checkkeys_OSJAG_Directory.o
$(EXEDIR)/graywin_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/graywin.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(RUNTIME_OBJS) $(LIB_OS) $(ROOT_OBJC)/graywin_args.o $(ROOT_OBJASM)/graywin_OSJAG_Directory.o
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(O_EXTERN) $(RUNTIME_OBJS) $(LIB_OS) $(ROOT_OBJC)/graywin_args.o $(ROOT_OBJASM)/graywin_OSJAG_Directory.o
$(EXEDIR)/loopwave_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/loopwave.o $(ROOT_OBJC)/loopwave_args.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS) $(ROOT_OBJASM)/loopwave_OSJAG_Directory.o
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/loopwave_args.o $(ROOT_OBJASM)/loopwave_OSJAG_Directory.o
$(EXEDIR)/testalpha_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testalpha.o $(ROOT_OBJC)/testalpha_args.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testalpha_OSJAG_Directory.o
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/testalpha_args.o $(ROOT_OBJASM)/testalpha_OSJAG_Directory.o
$(EXEDIR)/testbitmap_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testbitmap.o $(ROOT_OBJC)/testbitmap_args.o $(ROOT_OBJASM)/testbitmap_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/testbitmap_args.o $(ROOT_OBJASM)/testbitmap_OSJAG_Directory.o
$(EXEDIR)/testblitspeed_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testblitspeed.o $(ROOT_OBJASM)/testblitspeed_OSJAG_Directory.o $(ROOT_OBJC)/testblitspeed_args.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/testblitspeed_args.o $(ROOT_OBJASM)/testblitspeed_OSJAG_Directory.o
$(EXEDIR)/testcdrom_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testcdrom.o $(ROOT_OBJC)/testcdrom_args.o $(ROOT_OBJASM)/testcdrom_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testcdrom_OSJAG_Directory.o $(ROOT_OBJC)/testcdrom_args.o
$(EXEDIR)/testcursor_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testcursor.o $(ROOT_OBJC)/testcursor_args.o $(ROOT_OBJASM)/testcursor_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/testcursor_args.o $(ROOT_OBJASM)/testcursor_OSJAG_Directory.o
$(EXEDIR)/testdyngl_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testdyngl.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS) $(ROOT_OBJC)/testdyngl_args.o
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/testdyngl_args.o
$(EXEDIR)/testerror_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testerror.o $(ROOT_OBJASM)/testerror_OSJAG_Directory.o $(ROOT_OBJC)/testerror_args.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/testerror_args.o $(ROOT_OBJASM)/testerror_OSJAG_Directory.o
$(EXEDIR)/testfile_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testfile.o $(ROOT_OBJC)/testfile_args.o $(ROOT_OBJASM)/testfile_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testfile_OSJAG_Directory.o $(ROOT_OBJC)/testfile_args.o
$(EXEDIR)/testgamma_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testgamma.o $(ROOT_OBJC)/testgamma_args.o $(ROOT_OBJASM)/testgamma_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testgamma_OSJAG_Directory.o $(ROOT_OBJC)/testgamma_args.o
$(EXEDIR)/testgl_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testgl.o $(ROOT_OBJC)/testgl_args.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/testgl_args.o
$(EXEDIR)/testhread_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testhread.o $(ROOT_OBJC)/testhread_args.o $(ROOT_OBJASM)/testthread_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testthread_OSJAG_Directory.o $(ROOT_OBJC)/testhread_args.o
$(EXEDIR)/testiconv_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testiconv.o $(ROOT_OBJC)/testiconv_args.o $(ROOT_OBJASM)/testiconv_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testiconv_OSJAG_Directory.o $(ROOT_OBJC)/testiconv_args.o
$(EXEDIR)/testjoystick_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testjoystick.o $(ROOT_OBJC)/testjoystick_args.o $(ROOT_OBJASM)/testjoystick_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testjoystick_OSJAG_Directory.o $(ROOT_OBJC)/testjoystick_args.o
$(EXEDIR)/testkeys_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testkeys.o $(ROOT_OBJC)/testkeys_args.o $(ROOT_OBJASM)/testkeys_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testkeys_OSJAG_Directory.o $(ROOT_OBJC)/testkeys_args.o
$(EXEDIR)/testloadso_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testloadso.o $(ROOT_OBJC)/testloadso_args.o $(ROOT_OBJASM)/testloadso_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testloadso_OSJAG_Directory.o $(ROOT_OBJC)/testloadso_args.o
$(EXEDIR)/testlock_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testlock.o $(ROOT_OBJC)/testlock_args.o $(ROOT_OBJASM)/testlock_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testlock_OSJAG_Directory.o $(ROOT_OBJC)/testlock_args.o
$(EXEDIR)/testoverlay_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testoverlay.o $(ROOT_OBJC)/testoverlay_args.o $(ROOT_OBJASM)/testoverlay_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testoverlay_OSJAG_Directory.o $(ROOT_OBJC)/testoverlay_args.o
$(EXEDIR)/testoverlay2_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testoverlay2.o $(ROOT_OBJC)/testoverlay2_args.o $(ROOT_OBJASM)/testoverlay2_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testoverlay2_OSJAG_Directory.o $(ROOT_OBJC)/testoverlay2_args.o
$(EXEDIR)/testpalette_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testpalette.o $(ROOT_OBJC)/testpalette_args.o $(ROOT_OBJASM)/testpalette_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testpalette_OSJAG_Directory.o $(ROOT_OBJC)/testpalette_args.o
$(EXEDIR)/testplatform_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testplatform.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS) $(ROOT_OBJC)/testplatform_args.o
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/testplatform_args.o
$(EXEDIR)/testsem_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testsem.o $(ROOT_OBJC)/testsem_args.o $(ROOT_OBJASM)/testsem_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testsem_OSJAG_Directory.o $(ROOT_OBJC)/testsem_args.o
$(EXEDIR)/testsprite_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testsprite.o $(ROOT_OBJC)/testsprite_args.o $(ROOT_OBJASM)/testsprite_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testsprite_OSJAG_Directory.o $(ROOT_OBJC)/testsprite_args.o
$(EXEDIR)/testtimer_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testtimer.o $(ROOT_OBJC)/testtimer_args.o $(ROOT_OBJASM)/testtimer_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testtimer_OSJAG_Directory.o $(ROOT_OBJC)/testtimer_args.o
$(EXEDIR)/testver_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testver.o $(ROOT_OBJC)/testver_args.o $(ROOT_OBJASM)/testver_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testver_OSJAG_Directory.o $(ROOT_OBJC)/testver_args.o
$(EXEDIR)/testvidinfo_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testvidinfo.o $(ROOT_OBJC)/testvidinfo_args.o $(ROOT_OBJASM)/testvidinfo_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testvidinfo_OSJAG_Directory.o $(ROOT_OBJC)/testvidinfo_args.o
$(EXEDIR)/testwin_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testwin.o $(ROOT_OBJASM)/testwin_OSJAG_Directory.o $(ROOT_OBJC)/testwin_args.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/testwin_args.o $(ROOT_OBJASM)/testwin_OSJAG_Directory.o
$(EXEDIR)/testwm_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/testwm.o $(ROOT_OBJC)/testwm_args.o $(ROOT_OBJASM)/testwm_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/testwm_OSJAG_Directory.o $(ROOT_OBJC)/testwm_args.o
$(EXEDIR)/threadwin_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/threadwin.o $(ROOT_OBJC)/threadwin_args.o $(ROOT_OBJASM)/threadwin_OSJAG_Directory.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJASM)/threadwin_OSJAG_Directory.o  $(ROOT_OBJC)/threadwin_args.o
$(EXEDIR)/torturethread_$(mode)_$(COMPILER_SELECT).$(FORMAT):	$(ROOT_OBJC)/torturethread.o $(ROOT_OBJASM)/torturethread_OSJAG_Directory.o $(ROOT_OBJC)/torturethread_args.o $(FLSDIR)/AJagELFls $(LIB_SDL) $(LIB_GCC) $(LIBC) $(LIB_MATH) $(LIB_OS) $(RUNTIME_OBJS)
	@echo -e "\033[01;33m***\033[$(COLOR_LINKER)m Linking $@...\033[00m"
	$(Q)-$(LNKProg) $(DIR_LIBS) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(LIB_GCC) $(LIB_SDL) $(LIBC) $< $(LIB_MATH) $(LIB_OS) $(O_EXTERN) $(RUNTIME_OBJS) $(ROOT_OBJC)/torturethread_args.o $(ROOT_OBJASM)/torturethread_OSJAG_Directory.o


# SDL config
$(INCLUDE)\SDL_config.h:	$(INCLUDE)\SDL_config_ajaguar.h $(INCLUDE)\SDL_config.h.default
	@echo -e "\033[01;33m***\033[$(COLOR_UPDATING)m Copy updated config header file...\033[00m"
	$(Q)cp -u $(INCLUDE)\SDL_config.h.default $(INCLUDE)\SDL_config.h


makedirs:	mkdir_Runtime \
			mkdir_objs \
			mkdir_libs \
			mkdir_CtoS
#
# Create the Runtime's object files directories
mkdir_Runtime:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the Runtime directory...\033[00m"
		$(Q)mkdir -p $(ROOT_OBJASM)
		$(Q)mkdir -p $(ROOT_OBJC)
#
# Create the asm files, generated by compilation, directories		
mkdir_CtoS:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the generated asm directories...\033[00m"
		$(Q)mkdir -p $(CtoSDIR)
#
# Create the external libraries files directories
mkdir_libs:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the libs directories...\033[00m"
		$(Q)mkdir -p $(mode)/libs
		$(Q)mkdir -p $(mode)/libs/fdlibm
		$(Q)mkdir -p $(mode)/libs/OSJag
#
# Create the object files directories
mkdir_objs:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the objs directories...\033[00m"
		$(Q)mkdir -p $(OBJC)

		
# Display configuration
#
config:	config_command \
		config_opengl \
		config_generic \
		config_toolchain \
		config_compilation \
		config_assembling \
		config_linker \
		config_outdir \
		config_libs \
#
# Display the compilation information
config_compilation:
	$(info ----------- Compilation)
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
# Display the OpenGL information
config_opengl:
	$(info ----------- OpenGL)
	$(info OpenGL    : $(OPENGL_SELECT))
#
# Display the linking information
config_linker:
	$(info ----------- Linker)
	$(info Script    : $(LINKER_SCRIPT))
	$(info Options   : $(LINKER_OPTIONS))
#
# Display generic information
config_generic:
	$(info ----------- Generic)
	$(info Format    : $(FORMAT))
	$(info Assembler : $(ASM) $(VASM_SUPPORT))
	$(info Compiler  : $(COMPILER_C_TYPE) $(COMPILER_C_VERSION))
#
# Display the toolchain information
config_toolchain:
	$(info ----------- Toolchain)
	$(info Linker    : $(LNKProg))
	$(info Assembler : $(ASMProg))
	$(info Compiler  : $(CCProg))
	$(info Library   : $(ARProg))
	$(info Library   : $(ARANProg))
#
# Display libraries specific information
config_libs:
	$(info ----------- Libraries)
	$(info C         : $(LIBC))
	$(info GCC       : $(LIB_GCC))
	$(info Maths     : $(LIB_MATH))
	$(info OS        : $(LIB_OS))
	$(info SDL       : $(LIB_SDL))
#
# Display the output directories
config_outdir:
	$(info ----------- Output directories)
	$(info C-->asm   : $(CtoSDIR))
