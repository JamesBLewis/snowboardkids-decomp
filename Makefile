BASENAME  = snowboardkids

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
C_DEFINES    = -DLANGUAGE_C -D_LANGUAGE_C -D_MIPS_SZLONG=32 -DNDEBUG
CFLAGS       = -c -O1 -mips2 -G 0 -non_shared -fullwarn -Xcpluscomm \
               -nostdinc -Wab,-r4300_mul -woff 649,838,712,516 \
               -Iinclude $(C_DEFINES)
OBJCOPYFLAGS = -O binary
RM_MDEBUG    = $(OBJCOPY) --remove-section .mdebug $@

LD_SCRIPT      = $(BASENAME).ld
LINKER_SCRIPTS = linker_scripts/hardware_regs.ld linker_scripts/libultra_syms.ld
LDFLAGS        = -T $(LD_SCRIPT) -Map $(TARGET).map \
                 -T undefined_syms_auto.txt \
                 -T undefined_funcs_auto.txt \
                 $(foreach ld,$(LINKER_SCRIPTS),-T $(ld)) \
                 --no-check-sections

# Files

ASM_S_FILES := $(foreach dir,$(ASM_DIRS),$(wildcard $(dir)/*.s))
ASM_O_FILES := $(patsubst %.s,$(BUILD_DIR)/%.o,$(ASM_S_FILES))

C_FILES     := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
C_O_FILES   := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_FILES))

BIN_FILES   := $(foreach dir,$(BIN_DIRS),$(wildcard $(dir)/*.bin))
BIN_O_FILES := $(patsubst %.bin,$(BUILD_DIR)/%.o,$(BIN_FILES))

O_FILES := $(shell grep -E 'build/(asm|assets|src)/.+\.o' $(LD_SCRIPT) -o | sort | uniq)

TARGET = $(BUILD_DIR)/$(BASENAME)

### Targets

default: all

all: dirs $(TARGET).z64 verify

dirs:
	@mkdir -p $(BUILD_DIR)/asm/data
	@mkdir -p $(BUILD_DIR)/assets
	@mkdir -p $(BUILD_DIR)/src

extract: check
	$(SPLAT) $(BASENAME).yaml

#################
## COMPILATION ##
#################

# *.s -> *.o (through C preprocessor)
$(BUILD_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	$(CPP) $(CPPFLAGS) -I include $< | $(AS) $(ASFLAGS) -o $@

# *.c -> *.o
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(IDO_CC) $(CFLAGS) -o $@ $<
	$(RM_MDEBUG)

# *.bin -> *.o
$(BUILD_DIR)/%.o: %.bin
	@mkdir -p $(dir $@)
	$(LD) -r -b binary -o $@ $<

# *.o -> *.elf
$(TARGET).elf: $(O_FILES)
	$(LD) $(LDFLAGS) -o $@

# *.elf -> *.bin
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

# *.bin -> *.z64 (with N64 CRC)
$(TARGET).z64: $(TARGET).bin
	cp $< $@
	$(PYTHON) $(N64CRC) $@

# SHA1 verification
verify: $(TARGET).z64
	shasum --check $(BASENAME).sha1

# Check baserom exists
.PHONY: check
check:
	@if [ ! -f $(BASENAME).z64 ]; then echo "Error: $(BASENAME).z64 not found"; exit 1; fi

###########
## CLEAN ##
###########

clean:
	rm -rf asm
	rm -rf assets
	rm -rf build
	rm -f *auto.txt

### Settings
.SECONDARY:
.PHONY: all clean default extract verify check

# Include dependency file if it exists
-include $(BASENAME).d
