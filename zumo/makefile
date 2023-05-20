PORT = /dev/ttyUSB0

C++ = avr-g++
CC = avr-gcc
LD = avr-gcc
RM = rm -f

MCU = atmega32u4
TARGET = main
SRCS += main.cpp

C_CPP_FLAGS += -mmcu=$(MCU)
C_CPP_FLAGS += -Wl,-gc-sections
SHARED_FLAGS += -Os

C_CPP_FLAGS += -mcall-prologues
C_CPP_FLAGS += -g
C_CPP_FLAGS += -Wl,-relax
C_CPP_FLAGS += -MMD
C_CPP_FLAGS += -ffunction-sections
C_CPP_FLAGS += -fdata-sections

LFLAGS += -flto
LFLAGS += -fuse-linker-plugin
LFLAGS += -lc -lm
# LFLAGS += -L/usr/avr/lib/avr5/ -L/usr/lib/gcc/avr/12.2.0/avr5 -lgcc -lm -lc -latmega32u4
# LFLAGS += -flto -fuse-linker-plugin -mmcu=atmega32u4 -Wl,--gc-sections -Os -lc -lm


CFLAGS += -fno-fat-lto-objects
# CFLAGS += -std=gnu11

CPPFLAGS += -fpermissive
CPPFLAGS += -fno-exceptions
CPPFLAGS += -fno-threadsafe-statics
CPPFLAGS += -fno-devirtualize
# CPPFLAGS += -std=gnu++11


LFLAGS += $(SHARED_FLAGS)
CFLAGS += $(C_CPP_FLAGS) $(SHARED_FLAGS)
CPPFLAGS += $(C_CPP_FLAGS) $(SHARED_FLAGS)

include zumo.mk

OBJS := $(patsubst %.c,%.o, $(SRCS))
OBJS := $(patsubst %.cpp,%.o, $(OBJS))

MAKEFLAGS += -j

.PHONY: all clean flash

all: $(TARGET).hex

%.o: %.cpp
	$(C++) $(CPPFLAGS) -o $@ -c $<

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

$(TARGET): $(OBJS)
	$(LD) $(LFLAGS) -o $@ $^

$(TARGET).hex: $(TARGET)
	avr-objcopy -R .eeprom -O ihex $< $@

flash: $(TARGET).hex
	avrdude -p $(MCU) -c avr109 -P $(PORT) -U flash:w:$(TARGET).hex

clean:
	$(RM) $(TARGET) $(TARGET).hex $(OBJS)

compile_commands.json: makefile
	compiledb make -Bn
