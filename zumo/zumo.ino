#include <Zumo32U4.h>
#include <Arduino.h>
#include <Wire.h>

#include "control.h"
#include "protocol.h"
#include "pid.h"

dui_state_t g_dui_target_state = {
	.steer = 0.0f,
	.speed = 0.0f,
	.current_sign = DUI_SIGN_NONE,
	.speed_mod = 1.f,
};
dui_state_t g_dui_current_state = {
	.steer = 0.f,
	.speed = 0.f,
	.current_sign = DUI_SIGN_NONE,
	.speed_mod = 1.f,
};

void setup() {
	pinMode(DUI_PINOUT_NICLA_TX, OUTPUT);
	pinMode(DUI_PINOUT_NICLA_RX, INPUT_PULLUP);
	Serial.begin(115200);
}

void loop() {
	static unsigned char cmd_old = 0x00;
	for (unsigned int i = 0; i < 1000; i++) {
		digitalWrite(DUI_PINOUT_NICLA_TX, LOW);
		unsigned char cmd = uart_read();
		if (cmd == 0x00) continue;
		if (cmd == cmd_old) handle_cmd(cmd, &g_dui_target_state);
		cmd_old = cmd;
	}
	digitalWrite(DUI_PINOUT_NICLA_TX, HIGH);

	apply_pid(&g_dui_target_state, &g_dui_current_state);
	g_dui_current_state.current_sign = g_dui_target_state.current_sign;

	apply_state(&g_dui_current_state);
}
