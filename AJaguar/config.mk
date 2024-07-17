# Makefile config for the SDL 1.2 Atari Jaguar library


# Format selection (elf)
FORMAT = elf


# Assembler selection (rmac, vasm)
ASM = vasm
# VASM information (madmac, std)
ifeq ($(ASM), vasm)
VASM_SUPPORT = std
endif
# Compiler C type (gcc)
COMPILER_C_TYPE	= gcc
# Compiler C version depend his type
COMPILER_C_VERSION = 4.9.3
# Compiler tools version depend his type
COMPILER_TOOLS_VERSION = 13.1.0
# Compiler selection based on type and version
COMPILER_C = $(COMPILER_C_TYPE)$(COMPILER_C_VERSION)
# Compiler selection based on type, and version
COMPILER_SELECT	= $(COMPILER_C_TYPE)-$(COMPILER_C_VERSION)
# Linker selection (vlink)
LINKER_SELECT =	vlink


# Linker information
#
ifeq ($(LINKER_SELECT), vlink)
LNKProg = C:/VB/vlink0.17a
else
$(error LINKER_SELECT is not set or wrongly dispatched)
endif


# ASM information
#
ifeq ($(ASM), vasm)
ASMProg	= C:/VB/Vasmm68k/vasmm68k_$(VASM_SUPPORT)_win32_1.9f
else
ifeq ($(ASM), rmac)
ASMProg	= C:/Tools/RmacRln/rmac.exe
else
$(error ASM is not set or wrongly dispatched)
endif
endif


# Tools executables
ARProg = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin/m68k-$(FORMAT)-ar
ARANProg = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin/m68k-$(FORMAT)-ranlib
readelf	= C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin/m68k-$(FORMAT)-readelf
stripelf = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin/m68k-$(FORMAT)-strip
objdump = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin/m68k-$(FORMAT)-objdump


# C compiler, includes & library information
#
# GCC
#
ifeq ($(COMPILER_C_TYPE), gcc)
# gcc compiler
ifneq ("$(wildcard C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_C_VERSION)/bin)","")
CCPATH = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_C_VERSION)
CCProg = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_C_VERSION)/bin/m68k-$(FORMAT)-gcc -B$(CCPATH)/libexec/gcc/m68k-$(FORMAT)/$(COMPILER_C_VERSION)/ -B$(CCPATH)/m68k-$(FORMAT)/bin/
else
$(error GNU/gcc $(COMPILER_C_VERSION) is wrongly dispatched)
endif
# gcc headers library
ifneq ("$(wildcard C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_C_VERSION)/m68k-$(FORMAT)/include)","")
CCINC1 = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_C_VERSION)/m68k-$(FORMAT)/include
CCINC2 = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_C_VERSION)/lib/gcc/m68k-$(FORMAT)/$(COMPILER_C_VERSION)/include
else
CCINC1 = C:/GNU/m68k-$(FORMAT)-gcc-4.9.3/m68k-$(FORMAT)/include
CCINC2 = C:/GNU/m68k-$(FORMAT)-gcc-4.9.3/lib/gcc/m68k-$(FORMAT)/4.9.3/include
endif
# gcc libraries
ifneq ("$(wildcard C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_C_VERSION)/lib/gcc/m68k-$(FORMAT)/$(COMPILER_C_VERSION)/mcpu32)", "")
DIRLIBGCC = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_C_VERSION)/lib/gcc/m68k-$(FORMAT)/$(COMPILER_C_VERSION)
DIRLIBC = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_C_VERSION)/m68k-$(FORMAT)/lib
else
DIRLIBGCC = C:/GNU/m68k-$(FORMAT)-gcc-4.9.3/lib/gcc/m68k-$(FORMAT)4.9.3
DIRLIBC = C:/GNU/m68k-$(FORMAT)-gcc-4.9.3/m68k-$(FORMAT)/lib
endif
#
# Compiler not set
#
else
$(error COMPILER_C_TYPE is not set or wrongly dispatched)
endif
