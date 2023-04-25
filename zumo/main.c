#define F_CPU 16000000

#include <avr/io.h>
#include <util/delay.h>

int main() {
	DDRC |= (1 << DDC7);
	while(1) {
		PORTC |= (1 << PORTC7);
		_delay_ms(500);
		PORTC &= ~(1 << PORTC7);
		_delay_ms(500);
	}
}

