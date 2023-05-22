#include "UartRecive.h"

SoftwareSerial mySerial(rxPin, txPin, true);
char receivedData[maxDataLength];
int dataLength = 0;

void setupSerialCommunication() {
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);

  Serial.begin(9600);
  mySerial.begin(9600);
}

void processSerialData() {
  if (mySerial.available()) {
    char receivedChar = mySerial.read();

    char invertedChar = receivedChar;

    if (dataLength < maxDataLength - 1) {
      receivedData[dataLength] = invertedChar;
      dataLength++;
    }

    Serial.print("Decimal value: ");
    Serial.println(static_cast<int>(invertedChar));
  }
}
