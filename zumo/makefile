PORT = /dev/ttyUSB0

C++ = avr-g++
CC = avr-gcc
LD = avr-ld
RM = rm -f

MCU = atmega32u4
TARGET = main
SRCS += main.cpp

CFLAGS += -mcall-prologues
CFLAGS += -mmcu=$(MCU)
CFLAGS += -Os
CFLAGS += -g
CFLAGS += -Wl,-gc-sections
CFLAGS += -Wl,-relax

include zumo.mk

OBJS := $(patsubst %.c,%.o, $(SRCS))
OBJS := $(patsubst %.cpp,%.o, $(OBJS))

MAKEFLAGS += -j4

.PHONY: all clean flash

all: $(TARGET).hex

%.o: %.cpp
	$(C++) -c $(CFLAGS) $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

$(TARGET): $(OBJS)
	$(LD) $^ $(LFLAGS) -o $@

$(TARGET).hex: $(TARGET)
	avr-objcopy -R .eeprom -O ihex $< $@

flash: $(TARGET).hex
	avrdude -p $(MCU) -c avr109 -P $(PORT) -U flash:w:$(TARGET).hex

clean:
	$(RM) $(TARGET) $(TARGET).hex $(OBJS)

compile_commands.json: makefile
	compiledb make -Bn
