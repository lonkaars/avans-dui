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

CFLAGS += -L/usr/avr/lib/avr5/ -L/usr/lib/gcc/avr/12.2.0/avr5 -lgcc -lm -lc -latmega32u4
LFLAGS += -L/usr/avr/lib/avr5/ -L/usr/lib/gcc/avr/12.2.0/avr5 -lgcc -lm -lc -latmega32u4

LIBS += lib/ArduinoCore-avr/cores/arduino/PluggableUSB.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/CDC.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/HardwareSerial.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/USBCore.cpp
# LIBS += lib/ArduinoCore-avr/cores/arduino/HardwareSerial0.cpp
# LIBS += lib/ArduinoCore-avr/cores/arduino/HardwareSerial1.cpp
# LIBS += lib/ArduinoCore-avr/cores/arduino/HardwareSerial2.cpp
# LIBS += lib/ArduinoCore-avr/cores/arduino/HardwareSerial3.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/IPAddress.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/Print.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/Stream.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/WMath.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/WString.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/abi.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/main.cpp
LIBS += lib/ArduinoCore-avr/cores/arduino/new.cpp
LIBS += lib/ArduinoCore-avr/libraries/HID/src/HID.cpp
LIBS += lib/ArduinoCore-avr/libraries/SPI/src/SPI.cpp
# LIBS += lib/ArduinoCore-avr/libraries/SoftwareSerial/src/SoftwareSerial.cpp
LIBS += lib/ArduinoCore-avr/libraries/Wire/src/Wire.cpp
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
# LIBS += lib/ArduinoCore-avr/cores/arduino/Tone.cpp
# LIBS += lib/ArduinoCore-avr/libraries/Wire/src/utility/twi.c

LIBS += lib/ArduinoCore-avr/cores/arduino/WInterrupts.c
LIBS += lib/ArduinoCore-avr/cores/arduino/hooks.c
LIBS += lib/ArduinoCore-avr/cores/arduino/wiring_shift.c
LIBS += lib/ArduinoCore-avr/cores/arduino/wiring_digital.c
LIBS += lib/ArduinoCore-avr/cores/arduino/wiring_analog.c
# LIBS += lib/ArduinoCore-avr/cores/arduino/wiring_pulse.c
LIBS += lib/ArduinoCore-avr/cores/arduino/wiring.c

SRCS += $(LIBS)

