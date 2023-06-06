CPP = g++
LD = g++
RM = rm -f
CFLAGS =
LFLAGS =
TARGET = protocoltest

SRCS := $(TARGET).cpp ../protocol.cpp
OBJS := $(TARGET).o ../protocol.o

all: $(TARGET)

%.o: %.cpp
	$(CPP) -c $(CFLAGS) $< -o $@

$(TARGET): $(OBJS)
	$(LD) $^ $(LFLAGS) -o $@

clean:
	$(RM) $(TARGET) $(OBJS)

