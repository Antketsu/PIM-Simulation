ROOT_DIR := $(abspath ../..)
GEM5_PATH ?= $(ROOT_DIR)/gem5-pim
ISA = arm64
CC = aarch64-linux-gnu-gcc


PIM_DIR := $(CURDIR)
BUILD_DIR := $(CURDIR)/../build


CFLAGS = -g -I$(GEM5_PATH)/include -I$(PIM_DIR) -O3
LDFLAGS = -L$(GEM5_PATH)/util/m5/build/$(ISA)/out -static
LDLIBS = -lm5

TARGETS := $(BUILD_DIR)/add_pim $(BUILD_DIR)/conv_pim \
	$(BUILD_DIR)/mul_pim $(BUILD_DIR)/mul_copy_pim


# Rules

all: $(TARGETS)

$(BUILD_DIR)/add_pim: add.c pim.c pim.h | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $< pim.c $(LDFLAGS) $(LDLIBS)

$(BUILD_DIR)/conv_pim: conv.c pim.c pim.h | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $< pim.c $(LDFLAGS) $(LDLIBS)

$(BUILD_DIR)/mul_pim: mult.c pim.c pim.h | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $< pim.c $(LDFLAGS) $(LDLIBS)

$(BUILD_DIR)/mul_copy_pim: mult_copy.c pim.c pim.h | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $< pim.c $(LDFLAGS) $(LDLIBS)

$(BUILD_DIR):
	mkdir -p "$@"

clean:
	rm -f $(TARGETS)

.PHONY: all clean
