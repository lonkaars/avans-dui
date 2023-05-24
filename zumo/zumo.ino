#include <Zumo32U4.h>
#include <Arduino.h>
#include <Wire.h>

#include "protocol.h"
#include "pid.h"

#define DUI_PINOUT_NICLA_TX 13
#define DUI_PINOUT_NICLA_RX 14

dui_state_t g_dui_target_state = {
	.steer = 1.0f,
	.speed = 1.0f,
	.current_sign = DUI_SIGN_NONE,
	.speed_mod = 1.f,
};
dui_state_t g_dui_current_state = {
	.steer = 0.f,
	.speed = 1.f,
	.current_sign = DUI_SIGN_NONE,
	.speed_mod = 1.f,
};

void setup() {
	pinMode(DUI_PINOUT_NICLA_TX, OUTPUT);
	pinMode(DUI_PINOUT_NICLA_RX, INPUT_PULLUP);
}

void loop() {
	unsigned char cmd = 0x00;
	while ((cmd = uart_read()))
		handle_cmd(cmd, &g_dui_target_state);

	apply_pid(&g_dui_target_state, &g_dui_current_state);

	apply_state(&g_dui_current_state);
}
