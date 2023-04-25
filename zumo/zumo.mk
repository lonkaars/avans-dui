CFLAGS += -DF_CPU=16000000
CFLAGS += -I./lib/zumo-32u4-arduino-library/src
CFLAGS += -I./lib/fastgpio-arduino
CFLAGS += -I./lib/pushbutton-arduino
CFLAGS += -I./lib/usb-pause-arduino
CFLAGS += -I./lib/pololu-buzzer-arduino/src
CFLAGS += -I./lib/pololu-hd44780-arduino
CFLAGS += -I./lib/pololu-menu-arduino/src
CFLAGS += -I./lib/pololu-oled-arduino/src
CFLAGS += -I./lib/ArduinoCore-avr/cores/arduino
CFLAGS += -I./lib/ArduinoCore-avr/libraries/HID/src
CFLAGS += -I./lib/ArduinoCore-avr/libraries/SoftwareSerial/src
CFLAGS += -I./lib/ArduinoCore-avr/libraries/SPI/src
CFLAGS += -I./lib/ArduinoCore-avr/libraries/EEPROM/src
CFLAGS += -I./lib/ArduinoCore-avr/libraries/Wire/src
CFLAGS += -I./lib/ArduinoCore-avr/variants/circuitplay32u4

LIBS += lib/ArduinoCore-avr/libraries/HID/src/HID.cpp \
				lib/ArduinoCore-avr/libraries/SoftwareSerial/src/SoftwareSerial.cpp \
				lib/ArduinoCore-avr/libraries/SPI/src/SPI.cpp \
				lib/ArduinoCore-avr/libraries/Wire/src/Wire.cpp \
				lib/ArduinoCore-avr/cores/arduino/HardwareSerial1.cpp \
				lib/ArduinoCore-avr/cores/arduino/HardwareSerial0.cpp \
				lib/ArduinoCore-avr/cores/arduino/WString.cpp \
				lib/ArduinoCore-avr/cores/arduino/PluggableUSB.cpp \
				lib/ArduinoCore-avr/cores/arduino/WMath.cpp \
				lib/ArduinoCore-avr/cores/arduino/IPAddress.cpp \
				lib/ArduinoCore-avr/cores/arduino/abi.cpp \
				lib/ArduinoCore-avr/cores/arduino/HardwareSerial.cpp \
				lib/ArduinoCore-avr/cores/arduino/CDC.cpp \
				lib/ArduinoCore-avr/cores/arduino/new.cpp \
				lib/ArduinoCore-avr/cores/arduino/Stream.cpp \
				lib/ArduinoCore-avr/cores/arduino/HardwareSerial2.cpp \
				lib/ArduinoCore-avr/cores/arduino/Print.cpp \
				lib/ArduinoCore-avr/cores/arduino/main.cpp \
				lib/ArduinoCore-avr/cores/arduino/HardwareSerial3.cpp \
				lib/pololu-buzzer-arduino/src/PololuBuzzer.cpp \
				lib/pushbutton-arduino/Pushbutton.cpp \
				lib/zumo-32u4-arduino-library/src/QTRSensors.cpp \
				lib/zumo-32u4-arduino-library/src/Zumo32U4IRPulses.cpp \
				lib/zumo-32u4-arduino-library/src/Zumo32U4Encoders.cpp \
				lib/zumo-32u4-arduino-library/src/Zumo32U4IMU.cpp \
				lib/zumo-32u4-arduino-library/src/Zumo32U4Motors.cpp \
				lib/zumo-32u4-arduino-library/src/Zumo32U4ProximitySensors.cpp \
				lib/usb-pause-arduino/USBPause.cpp \
				lib/pololu-hd44780-arduino/PololuHD44780.cpp \
				lib/fastgpio-arduino/FastGPIO.cpp \
				lib/pololu-oled-arduino/src/font.cpp
# lib/ArduinoCore-avr/cores/arduino/Tone.cpp
# lib/ArduinoCore-avr/libraries/Wire/src/utility/twi.c

LIBS += lib/ArduinoCore-avr/cores/arduino/WInterrupts.c \
				lib/ArduinoCore-avr/cores/arduino/hooks.c \
				lib/ArduinoCore-avr/cores/arduino/wiring_shift.c \
				lib/ArduinoCore-avr/cores/arduino/wiring_digital.c \
				lib/ArduinoCore-avr/cores/arduino/wiring_analog.c \
				lib/ArduinoCore-avr/cores/arduino/wiring_pulse.c \
				lib/ArduinoCore-avr/cores/arduino/wiring.c

SRCS += $(LIBS)

