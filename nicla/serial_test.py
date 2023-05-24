from pyb import Pin, delay

zumo_tx = Pin("PA10", Pin.IN)
zumo_rx = Pin("PA9", Pin.OUT_PP)

def uart_send(s):
    zumo_rx.value(0)
    byte = ord(s)
    print("START BIT")
    delay(2)
    for x in range(8):
        bit = (byte & (1 << 7)) >> 7
        byte <<= 1
        zumo_rx.value(bit)
        print(f"BIT[{x}] = {bit}")
        delay(2)
    print("STOP BIT")
    zumo_rx.value(1)

while True:
    uart_send("a")
