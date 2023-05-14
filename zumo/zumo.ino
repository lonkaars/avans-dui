#include <Zumo32U4.h>
#include <Arduino.h>
#include <Wire.h>

#include "protocol.h"

dui_state_t g_dui_target_state = {
	.steer = 1.0f,
	.speed = 1.0f,
	.current_sign = DUI_SIGN_NONE,
	.speed_mod =96.0,
};
dui_state_t g_dui_current_state = {
	.steer = 0,
	.speed = 0,
	.current_sign = DUI_SIGN_NONE,
	.speed_mod = 1.0,
};

void setup() {
}

void loop() {
	unsigned char cmd = 0;
	while ((cmd = uart_read()))
		handle_cmd(cmd, &g_dui_target_state);

	//TODO: PID controllers + sign handlers

	apply_state(&g_dui_target_state);
}
