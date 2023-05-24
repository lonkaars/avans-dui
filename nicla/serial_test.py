from pyb import Pin, delay, udelay

zumo_tx = Pin("PA10", Pin.IN)
zumo_rx = Pin("PA9", Pin.OUT_PP)

def uart_send(byte):
    zumo_rx.value(0)
    udelay(1000)
    for x in range(8):
        bit = (byte & (1 << 7)) >> 7
        byte <<= 1
        zumo_rx.value(bit)
        udelay(1000)
    zumo_rx.value(1)

while True:
    # uart_send("a")
    for x in range(8):
        n = 1 << x
        uart_send(n)
        print(f"0x{n:02x}")
        delay(1000)
