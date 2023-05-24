#include <Zumo32U4Motors.h>
#include <Arduino.h>
#include <Wire.h>

#include "protocol.h"

#define DUI_SPEED_MOD 96.0f
#define DUI_MOTOR_DIFF 0.6f

void apply_state(dui_state_t *state) {
	float motor_l = 0.5f * state->speed * (+1.f * state->steer * DUI_MOTOR_DIFF - DUI_MOTOR_DIFF + 2) * state->speed_mod * DUI_SPEED_MOD;
	float motor_r = 0.5f * state->speed * (-1.f * state->steer * DUI_MOTOR_DIFF - DUI_MOTOR_DIFF + 2) * state->speed_mod * DUI_SPEED_MOD;

	Zumo32U4Motors::setLeftSpeed((int16_t) motor_l);
	Zumo32U4Motors::setRightSpeed((int16_t) motor_r);

	// TODO: print sign on OLED screen
}

inline bool rx() { return !digitalRead(DUI_PINOUT_NICLA_RX); }

unsigned char uart_read() {
	if (rx() == true) return 0x00; // return immediately if line is idle

	delayMicroseconds(1500); // wait out start bit

	unsigned char byte = 0x00;
	for (unsigned int i = 0; i < 8; i++) {
		byte = (byte << 1) | rx();
		delayMicroseconds(1000);
	}

	delayMicroseconds(1000); // wait out stop bit

	return byte;
}

