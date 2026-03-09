GEM5_PATH = /homelocal/antoma19_local/u/cnm/gem5/gem5
ISA = x86
CC = gcc


PIM_DIR = ..


CFLAGS = -I$(GEM5_PATH)/include -I$(PIM_DIR)
LDFLAGS = -L$(GEM5_PATH)/util/m5/build/$(ISA)/out -static
LDLIBS = -lm5


SOURCES = $(wildcard *.c)

TARGETS = $(SOURCES:.c=)

# Rules

all: $(TARGETS)

%: %.c $(PIM_DIR)/pim.c $(PIM_DIR)/pim.h
	$(CC) $(CFLAGS) -o $@ $< $(PIM_DIR)/pim.c $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(TARGETS)

.PHONY: all clean