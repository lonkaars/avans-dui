C_CPP_FLAGS += -DF_CPU=16000000L
C_CPP_FLAGS += -D__PROG_TYPES_COMPAT__
C_CPP_FLAGS += -DARDUINO=1819
C_CPP_FLAGS += -DARDUINO_AVR_LEONARDO
C_CPP_FLAGS += -DARDUINO_ARCH_AVR
C_CPP_FLAGS += -DARDUINO_BOARD='"AVR_LEONARDO"'
C_CPP_FLAGS += -DARDUINO_VARIANT='"leonardo"'
C_CPP_FLAGS += -DUSB_VID=0x2341
C_CPP_FLAGS += -DUSB_PID=0x8036
C_CPP_FLAGS += -DUSB_PRODUCT='"Arduino Leonardo"'
C_CPP_FLAGS += -DUSB_MANUFACTURER='"Unknown"'

C_CPP_FLAGS += -I./lib/zumo-32u4-arduino-library/src
C_CPP_FLAGS += -I./lib/fastgpio-arduino
C_CPP_FLAGS += -I./lib/pushbutton-arduino
C_CPP_FLAGS += -I./lib/usb-pause-arduino
C_CPP_FLAGS += -I./lib/pololu-buzzer-arduino/src
C_CPP_FLAGS += -I./lib/pololu-hd44780-arduino
C_CPP_FLAGS += -I./lib/pololu-menu-arduino/src
C_CPP_FLAGS += -I./lib/pololu-oled-arduino/src
C_CPP_FLAGS += -I./lib/ArduinoCore-avr/cores/arduino
C_CPP_FLAGS += -I./lib/ArduinoCore-avr/libraries/HID/src
C_CPP_FLAGS += -I./lib/ArduinoCore-avr/libraries/SoftwareSerial/src
C_CPP_FLAGS += -I./lib/ArduinoCore-avr/libraries/SPI/src
C_CPP_FLAGS += -I./lib/ArduinoCore-avr/libraries/EEPROM/src
C_CPP_FLAGS += -I./lib/ArduinoCore-avr/libraries/Wire/src
C_CPP_FLAGS += -I./lib/ArduinoCore-avr/variants/leonardo

# LIBS += lib/ArduinoCore-avr/cores/arduino/PluggableUSB.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/CDC.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/HardwareSerial.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/USBCore.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/HardwareSerial0.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/HardwareSerial1.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/HardwareSerial2.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/HardwareSerial3.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/IPAddress.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/Print.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/Stream.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/WMath.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/WString.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/abi.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/main.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/new.cpp
# LIBS += lib/ArduinoCore-avr/libraries/HID/src/HID.cpp
# LIBS += lib/ArduinoCore-avr/libraries/SPI/src/SPI.cpp
# LIBS += lib/ArduinoCore-avr/libraries/SoftwareSerial/src/SoftwareSerial.cpp
LIBS += lib/ArduinoCore-avr/libraries/Wire/src/Wire.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/WInterrupts.c
LIBS += lib/ArduinoCore-avr/cores/arduino/hooks.c
LIBS += lib/ArduinoCore-avr/cores/arduino/wiring_shift.c
LIBS += lib/ArduinoCore-avr/cores/arduino/wiring_digital.c
LIBS += lib/ArduinoCore-avr/cores/arduino/wiring_analog.c
LIBS += lib/ArduinoCore-avr/cores/arduino/wiring_pulse.c
LIBS += lib/ArduinoCore-avr/cores/arduino/wiring.c
LIBS += lib/ArduinoCore-avr/cores/arduino/Tone.cpp
# LIBS += lib/ArduinoCore-avr/libraries/Wire/src/utility/twi.c

LIBS += lib/pololu-buzzer-arduino/src/PololuBuzzer.cpp
LIBS += lib/pushbutton-arduino/Pushbutton.cpp
LIBS += lib/zumo-32u4-arduino-library/src/QTRSensors.cpp
LIBS += lib/zumo-32u4-arduino-library/src/Zumo32U4IRPulses.cpp
LIBS += lib/zumo-32u4-arduino-library/src/Zumo32U4Encoders.cpp
LIBS += lib/zumo-32u4-arduino-library/src/Zumo32U4IMU.cpp
LIBS += lib/zumo-32u4-arduino-library/src/Zumo32U4Motors.cpp
LIBS += lib/zumo-32u4-arduino-library/src/Zumo32U4ProximitySensors.cpp
LIBS += lib/usb-pause-arduino/USBPause.cpp
LIBS += lib/pololu-hd44780-arduino/PololuHD44780.cpp
LIBS += lib/fastgpio-arduino/FastGPIO.cpp
LIBS += lib/pololu-oled-arduino/src/font.cpp

SRCS += $(LIBS)

