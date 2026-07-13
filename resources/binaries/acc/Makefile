GEM5_PATH = /home/antonio/U/laburo/PIM-Simulation/gem5-pim
ISA = x86
CC = gcc


PIM_DIR = ..


CFLAGS = -g -I$(GEM5_PATH)/include -I$(PIM_DIR) -O3
LDFLAGS = -L$(GEM5_PATH)/util/m5/build/$(ISA)/out -static
LDLIBS = -lm5

ALL_C_FILES = $(wildcard *.c)

SOURCES = $(filter-out pim.c, $(wildcard *.c))

TARGETS = $(SOURCES:.c=)

ASM_FILES = $(ALL_C_FILES:.c=.s)


# Rules

all: $(TARGETS) $(ASM_FILES)

%: %.c pim.c pim.h
	$(CC) $(CFLAGS) -o $@ $< pim.c $(LDFLAGS) $(LDLIBS)

%.s: %.c pim.h
	$(CC) $(CFLAGS) -S -o $@ $<

clean:
	rm -f $(TARGETS)

.PHONY: all clean