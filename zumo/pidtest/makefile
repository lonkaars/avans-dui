CPP = g++
LD = g++
RM = rm -f
CFLAGS =
LFLAGS =
TARGET = pidtest

SRCS := pidtest.cpp ../pid.cpp
OBJS := pidtest.o ../pid.o

all: pidtest

%.o: %.cpp
	$(CPP) -c $(CFLAGS) $< -o $@

$(TARGET): $(OBJS)
	$(LD) $^ $(LFLAGS) -o $@

clean:
	$(RM) $(TARGET) $(OBJS)

