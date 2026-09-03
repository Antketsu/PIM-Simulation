GEM5_PATH = /home/antonio/U/laburo/PIM-Simulation/gem5-pim
ISA = arm64
CC = aarch64-linux-gnu-gcc

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

.PHONY: all clean