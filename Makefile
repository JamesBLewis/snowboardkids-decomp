BASENAME  = snowboardkids

ifndef QUIET
  PRINTF = @printf
else
  PRINTF = @true
endif

VERBOSE ?= 0
ifeq ($(VERBOSE),0)
  V := @
endif

# Colours

NO_COL  := \033[0m
RED     := \033[0;31m
RED2    := \033[1;31m
GREEN   := \033[0;32m
YELLOW  := \033[0;33m
BLUE    := \033[0;34m
PINK    := \033[0;35m
CYAN    := \033[0;36m

# Directories

BUILD_DIR = build
ASM_DIRS  = asm asm/data
BIN_DIRS  = assets
SRC_DIRS  = src
TOOLS_DIR = tools

# Tools

find-command = $(shell which $(1) 2>/dev/null)

ifneq      ($(call find-command,mips-linux-gnu-ld),)
  CROSS := mips-linux-gnu-
else ifneq ($(call find-command,mips64-linux-gnu-ld),)
  CROSS := mips64-linux-gnu-
else ifneq ($(call find-command,mips64-elf-ld),)
  CROSS := mips64-elf-
else
  $(error Unable to detect a suitable MIPS cross toolchain installed.)
endif

ifneq (,$(call find-command,$(CROSS)clang))
  CPP      := $(CROSS)clang
  CPPFLAGS := -E -P -x c
else ifneq (,$(call find-command,clang))
  CPP      := clang
  CPPFLAGS := -E -P -x c
else
  CPP      := cpp
  CPPFLAGS := -P
endif

AS      = $(CROSS)as
CC      = $(TOOLS_DIR)/ido-recomp/linux/cc
LD      = $(CROSS)ld
OBJDUMP = $(CROSS)objdump
OBJCOPY = $(CROSS)objcopy
PYTHON  = python3
SPLAT   = $(PYTHON) -m splat split
N64CRC  = $(TOOLS_DIR)/n64crc.py
ASM_PROC = $(TOOLS_DIR)/asm-processor/build.py

IDO_CC = $(PYTHON) $(ASM_PROC) $(CC) -- $(AS) $(ASFLAGS) --

# Flags

ASFLAGS      = -G 0 -I include -mips3 -mabi=32
C_DEFINES    = -DLANGUAGE_C -D_LANGUAGE_C -D_MIPS_SZLONG=32 -DNDEBUG \
               -DCOMPILING_LIBULTRA -DBUILD_VERSION=VERSION_I
C_MIPS       = -mips2
C_OPT        = -O2
CFLAGS       = -c $(C_MIPS) -G 0 -non_shared -fullwarn -Xcpluscomm \
               -nostdinc -Wab,-r4300_mul -woff 649,838,712,516 \
               -Iinclude $(C_DEFINES)
OBJCOPYFLAGS = -O binary
RM_MDEBUG    = $(OBJCOPY) --remove-section .mdebug $@

$(BUILD_DIR)/src/ultra/io/%.o: C_OPT = -O1
$(BUILD_DIR)/src/ultra/os/%.o: C_OPT = -O1
$(BUILD_DIR)/src/ultra/gu/%.o: C_OPT = -O1
$(BUILD_DIR)/src/ultra/gu/%.o: CFLAGS += -Iinclude/PR
$(BUILD_DIR)/src/ultra/gu/perspective.o: C_OPT = -O2

$(BUILD_DIR)/src/ultra/io/sptask.o: C_OPT = -O2
$(BUILD_DIR)/src/ultra/io/sptask.o: CFLAGS += -DF3DEX_GBI

$(BUILD_DIR)/src/ultra/libc/ll.o: C_OPT = -O1
$(BUILD_DIR)/src/ultra/libc/ll.o: C_MIPS = -mips3 -32

LD_SCRIPT      = $(BASENAME).ld
LINKER_SCRIPTS = linker_scripts/hardware_regs.ld linker_scripts/libultra_syms.ld
LDFLAGS        = -T $(LD_SCRIPT) -Map $(TARGET).map \
                 -T undefined_funcs_auto.txt \
                 -T undefined_syms_auto.txt \
                 $(foreach ld,$(LINKER_SCRIPTS),-T $(ld)) \
                 --no-check-sections \
                 --allow-multiple-definition

# Files

ASM_S_FILES := $(foreach dir,$(ASM_DIRS),$(wildcard $(dir)/*.s))
ASM_O_FILES := $(patsubst %.s,$(BUILD_DIR)/%.o,$(ASM_S_FILES))

C_FILES     := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
C_O_FILES   := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_FILES))

BIN_FILES   := $(foreach dir,$(BIN_DIRS),$(wildcard $(dir)/*.bin))
BIN_O_FILES := $(patsubst %.bin,$(BUILD_DIR)/%.o,$(BIN_FILES))

O_FILES := $(shell grep -E 'build/(asm|assets|src)/.+\.o' $(LD_SCRIPT) -o 2>/dev/null | sort | uniq)

TARGET = $(BUILD_DIR)/$(BASENAME)

### Targets

default: all

all: dirs $(TARGET).z64 verify

dirs:
	@mkdir -p $(BUILD_DIR)/asm/data
	@mkdir -p $(BUILD_DIR)/assets
	@mkdir -p $(BUILD_DIR)/src

extract: check
	$(PRINTF) "[$(CYAN) splat  $(NO_COL)]  Extracting $(BASENAME).yaml\n"
	$(V)$(SPLAT) $(BASENAME).yaml
	@# initialize.o defines data/bss locally for correct IDO codegen but
	@# the real data comes from the B1C00 data segment and libultra_syms.ld.
	$(V)sed -i '/build\/src\/ultra\/os\/initialize\.o(\.data)/d' $(LD_SCRIPT)
	$(V)sed -i '/build\/src\/ultra\/os\/initialize\.o(\.bss)/d' $(LD_SCRIPT)

#################
## COMPILATION ##
#################

# *.s -> *.o (through C preprocessor)
$(BUILD_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	$(PRINTF) "[$(GREEN)   as   $(NO_COL)]  $<\n"
	$(V)$(CPP) $(CPPFLAGS) -I include $< | $(AS) $(ASFLAGS) -o $@

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(PRINTF) "[$(GREEN)   c    $(NO_COL)]  $<\n"
	$(V)$(IDO_CC) $(CFLAGS) $(C_OPT) -o $@ $<
	$(V)$(RM_MDEBUG)

# Patch ll.o for modern binutils, matching the upstream libultra build.
$(BUILD_DIR)/src/ultra/libc/ll.o: src/ultra/libc/ll.c
	@mkdir -p $(dir $@)
	$(PRINTF) "[$(GREEN)   c    $(NO_COL)]  $<\n"
	$(V)$(IDO_CC) $(CFLAGS) $(C_OPT) -o $@ $<
	$(V)$(PYTHON) $(TOOLS_DIR)/set_o32abi_bit.py $@
	$(V)$(RM_MDEBUG)

# *.bin -> *.o
$(BUILD_DIR)/%.o: %.bin
	@mkdir -p $(dir $@)
	$(PRINTF) "[$(PINK) linker $(NO_COL)]  $<\n"
	$(V)$(LD) -r -b binary -o $@ $<

# *.o -> *.elf
$(TARGET).elf: $(LD_SCRIPT) undefined_funcs_auto.txt undefined_syms_auto.txt $(LINKER_SCRIPTS) $(O_FILES)
	$(PRINTF) "[$(PINK) linker $(NO_COL)]  Linking $(TARGET).elf\n"
	$(V)$(LD) $(LDFLAGS) -o $@

# *.elf -> *.bin
$(TARGET).bin: $(TARGET).elf
	$(PRINTF) "[$(CYAN) objcpy $(NO_COL)]  $<\n"
	$(V)$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

# *.bin -> *.z64 (with N64 CRC)
$(TARGET).z64: $(TARGET).bin
	$(PRINTF) "[$(CYAN) n64crc $(NO_COL)]  $@\n"
	$(V)cp $< $@
	$(V)$(PYTHON) $(N64CRC) $@

# SHA1 verification
verify: $(TARGET).z64
	$(PRINTF) "[$(GREEN) verify $(NO_COL)]  Checking $(BASENAME).sha1\n"
	$(V)shasum --check $(BASENAME).sha1

# Check baserom exists
.PHONY: check
check:
	@if [ ! -f $(BASENAME).z64 ]; then echo "Error: $(BASENAME).z64 not found" >&2; exit 1; fi

###########
## CLEAN ##
###########

clean:
	$(PRINTF) "[$(YELLOW) clean  $(NO_COL)]  Removing generated files\n"
	$(V)rm -rf asm
	$(V)rm -rf assets
	$(V)rm -rf build
	$(V)rm -f *auto.txt

### Settings
.SECONDARY:
.PHONY: all clean default extract verify check
