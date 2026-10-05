GEM5_PATH = /homelocal/antoma19_local/u/PIM-Simulation/gem5-pim
ISA = arm64
CC = aarch64-linux-gnu-gcc

ROOT_DIR := $(abspath ../../..)
OPENBLAS_DIR := $(CURDIR)/OpenBLAS
OPENBLAS_TARGET := openblas_fp16_sve_gemm
OPENBLAS_SOURCE := $(OPENBLAS_TARGET).c
OPENBLAS_CONV_TARGET := openblas_fp16_sve_conv
OPENBLAS_CONV_SOURCE := $(OPENBLAS_CONV_TARGET).c
OPENBLAS_LIB := $(OPENBLAS_DIR)/libopenblas.a
GEM5_BIN ?= $(GEM5_PATH)/build/ARM/gem5.opt
GEM5_CONFIG ?= $(ROOT_DIR)/resources/gem5_scripts/openblas_fp16_sve_gemm.py
GEM5_OUT ?= $(ROOT_DIR)/m5out/openblas_fp16_sve_gemm
GEM5_CONV_CONFIG ?= $(ROOT_DIR)/resources/gem5_scripts/openblas_fp16_sve_conv.py
GEM5_CONV_OUT ?= $(ROOT_DIR)/m5out/openblas_fp16_sve_conv
M ?= 2
N ?= 3
K ?= 2
CONV_H ?= 8
CONV_W ?= 16
CONV_C ?= 8
CONV_KH ?= 1
CONV_KW ?= 1
CONV_OC ?= 128
CONV_PRINT ?= 1

CFLAGS = -I$(GEM5_PATH)/include -O3
LDFLAGS = -L$(GEM5_PATH)/util/m5/build/$(ISA)/out -static
LDLIBS = -lm5

SOURCES = $(wildcard *.c)
TARGETS = $(SOURCES:.c=)
ASM_FILES = $(SOURCES:.c=.s)

# Rules

all: $(TARGETS) $(ASM_FILES)

# Regla para compilar el binario ejecutable final
%: %.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) $(LDLIBS)

# Regla específica para escupir el archivo de código ensamblador (.s)
%.s: %.c
	$(CC) $(CFLAGS) -S -o $@ $<

clean:
	rm -f $(TARGETS) $(ASM_FILES)

# OpenBLAS FP16/SVE executable. It is statically linked so gem5 SE mode does
# not need an AArch64 dynamic loader or a target-side OpenBLAS installation.
openblas: $(OPENBLAS_TARGET)

# SVE FP16 elementwise ADD baseline, without an OpenBLAS dependency.
add: add.c
	$(CC) -O3 -march=armv8.2-a+sve+fp16 \
		-I$(GEM5_PATH)/include add.c -static \
		-L$(GEM5_PATH)/util/m5/build/$(ISA)/out -lm5 -o $@

add.s: add.c
	$(CC) -O3 -march=armv8.2-a+sve+fp16 \
		-I$(GEM5_PATH)/include -S -o $@ $<

$(OPENBLAS_TARGET).s: $(OPENBLAS_SOURCE)
	$(CC) -O2 -march=armv8.2-a+sve -DBUILD_HFLOAT16=1 \
		-I$(OPENBLAS_DIR) -I$(GEM5_PATH)/include -S -o $@ $<

$(OPENBLAS_CONV_TARGET).s: $(OPENBLAS_CONV_SOURCE)
	$(CC) -O2 -march=armv8.2-a+sve -DBUILD_HFLOAT16=1 \
		-I$(OPENBLAS_DIR) -I$(GEM5_PATH)/include -S -o $@ $<

$(OPENBLAS_TARGET): $(OPENBLAS_SOURCE) $(OPENBLAS_LIB)
	$(CC) -O2 -march=armv8.2-a+sve -DBUILD_HFLOAT16=1 \
		-I$(OPENBLAS_DIR) -I$(GEM5_PATH)/include $(OPENBLAS_SOURCE) -static \
		-L$(OPENBLAS_DIR) -L$(GEM5_PATH)/util/m5/build/$(ISA)/out \
		-Wl,--start-group -lopenblas -lm -lpthread -ldl -lm5 \
		-Wl,--end-group -o $@

openblas-conv: $(OPENBLAS_CONV_TARGET)

$(OPENBLAS_CONV_TARGET): $(OPENBLAS_CONV_SOURCE) $(OPENBLAS_LIB)
	$(CC) -O2 -march=armv8.2-a+sve -DBUILD_HFLOAT16=1 \
		-I$(OPENBLAS_DIR) -I$(GEM5_PATH)/include $(OPENBLAS_CONV_SOURCE) -static \
		-L$(OPENBLAS_DIR) -L$(GEM5_PATH)/util/m5/build/$(ISA)/out \
		-Wl,--start-group -lopenblas -lm -lpthread -ldl -lm5 \
		-Wl,--end-group -o $@

gem5: $(OPENBLAS_TARGET)
	mkdir -p "$(GEM5_OUT)"
	M=$(M) N=$(N) K=$(K) "$(GEM5_BIN)" -d "$(GEM5_OUT)" -r "$(GEM5_CONFIG)"

gem5-conv: $(OPENBLAS_CONV_TARGET)
	mkdir -p "$(GEM5_CONV_OUT)"
	CONV_H=$(CONV_H) CONV_W=$(CONV_W) CONV_C=$(CONV_C) \
	CONV_KH=$(CONV_KH) CONV_KW=$(CONV_KW) CONV_OC=$(CONV_OC) \
	CONV_PRINT=$(CONV_PRINT) "$(GEM5_BIN)" -d "$(GEM5_CONV_OUT)" -r "$(GEM5_CONV_CONFIG)"

.PHONY: all clean openblas gem5 openblas-conv gem5-conv
