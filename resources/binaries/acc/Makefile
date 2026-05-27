GEM5_PATH = /home/antonio/U/laburo/PIM-Simulation/gem5-pim
ISA = arm64
CC = aarch64-linux-gnu-gcc


PIM_DIR = ..


CFLAGS = -g -I$(GEM5_PATH)/include -I$(PIM_DIR)
LDFLAGS = -L$(GEM5_PATH)/util/m5/build/$(ISA)/out -static
LDLIBS = -lm5


SOURCES = $(filter-out pim.c, $(wildcard *.c))

TARGETS = $(SOURCES:.c=)

# Rules

all: $(TARGETS)

%: %.c pim.c pim.h
	$(CC) $(CFLAGS) -o $@ $< pim.c $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(TARGETS)

.PHONY: all clean