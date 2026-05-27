GEM5_PATH = /home/antonio/U/laburo/PIM-Simulation/gem5-pim
ISA = arm64
CC = aarch64-linux-gnu-gcc



CFLAGS =  -O3 -I$(GEM5_PATH)/include
LDFLAGS = -L$(GEM5_PATH)/util/m5/build/$(ISA)/out -static
LDLIBS = -lm5


SOURCES = $(wildcard *.c)

TARGETS = $(SOURCES:.c=)

# Rules

all: $(TARGETS)

%: %.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(TARGETS)

.PHONY: all clean