ROOT_DIR := $(abspath ../..)
GEM5_PATH ?= $(ROOT_DIR)/gem5-pim
BUILD_DIR := $(CURDIR)/../build
OPENBLAS_DIR := $(CURDIR)/OpenBLAS
OPENBLAS_LIB := $(firstword $(wildcard $(OPENBLAS_DIR)/libopenblas*.a))

ISA := arm64
CC := aarch64-linux-gnu-gcc

OPENBLAS_GEMM := $(BUILD_DIR)/openblas_fp16_sve_gemm_cpu
OPENBLAS_CONV := $(BUILD_DIR)/openblas_fp16_sve_conv_cpu
TARGETS := $(BUILD_DIR)/add_cpu $(OPENBLAS_GEMM) $(OPENBLAS_CONV)

.PHONY: all clean openblas openblas-conv

all: $(TARGETS)

$(BUILD_DIR):
	mkdir -p "$@"

$(BUILD_DIR)/add_cpu: add.c | $(BUILD_DIR)
	$(CC) -O3 -march=armv8.2-a+sve+fp16 -I$(GEM5_PATH)/include $< -static \
		-L$(GEM5_PATH)/util/m5/build/$(ISA)/out -lm5 -o $@

$(OPENBLAS_GEMM): openblas_fp16_sve_gemm.c $(OPENBLAS_LIB) | $(BUILD_DIR)
	$(CC) -O2 -march=armv8.2-a+sve -DBUILD_HFLOAT16=1 \
		-I$(OPENBLAS_DIR) -I$(GEM5_PATH)/include $< -static \
		-L$(OPENBLAS_DIR) -L$(GEM5_PATH)/util/m5/build/$(ISA)/out \
		-Wl,--start-group $(OPENBLAS_LIB) -lm -lpthread -ldl -lm5 \
		-Wl,--end-group -o $@

$(OPENBLAS_CONV): openblas_fp16_sve_conv.c $(OPENBLAS_LIB) | $(BUILD_DIR)
	$(CC) -O2 -march=armv8.2-a+sve -DBUILD_HFLOAT16=1 \
		-I$(OPENBLAS_DIR) -I$(GEM5_PATH)/include $< -static \
		-L$(OPENBLAS_DIR) -L$(GEM5_PATH)/util/m5/build/$(ISA)/out \
		-Wl,--start-group $(OPENBLAS_LIB) -lm -lpthread -ldl -lm5 \
		-Wl,--end-group -o $@

openblas: $(OPENBLAS_GEMM)
openblas-conv: $(OPENBLAS_CONV)

clean:
	rm -f $(TARGETS)
