CPP = g++
LD = g++
RM = rm -f
CFLAGS =
LFLAGS =
TARGET = strlutest

SRCS := strlutest.cpp
OBJS := strlutest.o

all: strlutest

%.o: %.cpp
	$(CPP) -c $(CFLAGS) $< -o $@

$(TARGET): $(OBJS)
	$(LD) $^ $(LFLAGS) -o $@

clean:
	$(RM) $(TARGET) $(OBJS)

