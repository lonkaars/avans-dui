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

__uart_buffer = bytearray()
def uart_flush():
    global __uart_buffer
    # print("UART FLUSH START")
    for byte in __uart_buffer:
        # print(f"BYTE 0x{byte:02X}")
        uart_send(byte) # dit is de oplossing
        udelay(2000)
        uart_send(byte)
        udelay(2000)
        uart_send(byte)
        udelay(2000)
    __uart_buffer = bytearray()

def tx_irq_handler(pin):
    if pin is zumo_tx:
        uart_flush()

zumo_tx.irq(trigger = Pin.IRQ_RISING, handler = tx_irq_handler)

def uart_buffer(i):
    global __uart_buffer
    __uart_buffer.append(i)

if __name__ == "__main__":
    while True: # test commands
        uart_buffer(0x29)
        uart_buffer(0x70)
        delay(1000)
        uart_buffer(0xff)
        uart_buffer(0x20)
        delay(1000)
