#include <Zumo32U4Motors.h>

#include "protocol.h"

#define DUI_CMD_NULL 0x00
#define DUI_CMD_SIGN_START 0x01
#define DUI_CMD_SIGN_END 0x0f
#define DUI_CMD_STEER_START 0x10
#define DUI_CMD_STEER_END 0x1f
#define DUI_CMD_SPEED_START 0x20
#define DUI_CMD_SPEED_END 0xff

void handle_cmd(unsigned char cmd, dui_state_t *state) {
	if (cmd == DUI_CMD_NULL) return;
	else if (DUI_CMD_SIGN_START <= cmd && cmd <= DUI_CMD_SIGN_END) {
		state->current_sign = (dui_e_sign) (cmd - DUI_CMD_SIGN_START);
	} else if (DUI_CMD_STEER_START <= cmd && cmd <= DUI_CMD_STEER_END) {
		state->steer = (float) (cmd - DUI_CMD_STEER_START) / (float) (DUI_CMD_STEER_END - DUI_CMD_STEER_START);
	} else if (DUI_CMD_SPEED_START <= cmd && cmd <= DUI_CMD_SPEED_END) {
		state->speed = ((float) (cmd - DUI_CMD_SPEED_START) / (float) (DUI_CMD_SPEED_START - DUI_CMD_SPEED_END) * (float) 2 - (float) 1);
	}
}

void apply_state(dui_state_t *state) {
	const float MAX_MOTOR_DIFF = 0.6f; // 0 to 1
	float motor_l = 0.5f * state->speed * (+1.f * state->steer * MAX_MOTOR_DIFF - MAX_MOTOR_DIFF + 2) * state->speed_mod;
	float motor_r = 0.5f * state->speed * (-1.f * state->steer * MAX_MOTOR_DIFF - MAX_MOTOR_DIFF + 2) * state->speed_mod;

	Zumo32U4Motors::setLeftSpeed((int16_t) motor_l);
	Zumo32U4Motors::setRightSpeed((int16_t) motor_r);

	// TODO: print sign on OLED screen
}

unsigned char uart_read() {
	return 0x00;
}
