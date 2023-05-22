#ifndef SERIAL_COMMUNICATION_H
#define SERIAL_COMMUNICATION_H

#include <SoftwareSerial.h>

// Define software serial pins
const int rxPin = 14;  // Pin to receive data
const int txPin = 13;  // Pin to transmit data

extern SoftwareSerial mySerial;

const int maxDataLength = 100;
extern char receivedData[maxDataLength];
extern int dataLength;

void setupSerialCommunication();
void processSerialData();

#endif
