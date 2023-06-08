#pragma once

typedef enum {
	DUI_CMD_NULL,
	DUI_CMD_SIGN,
	DUI_CMD_SPEED,
	DUI_CMD_STEER,
} dui_e_cmd;

typedef enum {
	DUI_SIGN_NONE, /** @brief no sign */
	DUI_SIGN_STOP, /** @brief stop (set speed to 0) */
	DUI_SIGN_LEFT, /** @brief turn left (set steer to -1) */
	DUI_SIGN_RIGHT, /** @brief turn right (set steer to +1) */
	DUI_SIGN_SPEED_LIMIT_LOW, /** @brief slow down (speed limit 0.5) */
	DUI_SIGN_SPEED_LIMIT_HIGH, /** @brief full speed (speed limit 1.0) */
	DUI_SIGN_LIGHT_STOP, /** @brief traffic light red (set speed to 0) */
	DUI_SIGN_LIGHT_FLOOR_IT, /** @brief traffic light orange (set speed to 2 temporarily) */
	DUI_SIGN_LIGHT_GO, /** @brief traffic light green (keep current speed) */
} dui_e_sign;

const char* const DUI_SIGN_LOOKUP[16] = {
	[DUI_SIGN_NONE] = "",
	[DUI_SIGN_STOP] = "bord\nstop",
	[DUI_SIGN_LEFT] = "bord\nlinks",
	[DUI_SIGN_RIGHT] = "bord\nrechts",
	[DUI_SIGN_SPEED_LIMIT_LOW] = "snelheid\nlaag",
	[DUI_SIGN_SPEED_LIMIT_HIGH] = "snelheid\nhoog",
	[DUI_SIGN_LIGHT_STOP] = "stop.l.\nrood",
	[DUI_SIGN_LIGHT_FLOOR_IT] = "stop.l.\ngeel",
	[DUI_SIGN_LIGHT_GO] = "stop.l.\ngroen",
};

typedef struct {
	float steer; /** @brief steer value (-1 is left, +1 is right) */
	float Speed; /** @brief speed (0-15) */
	dui_e_sign current_sign; /** @brief last seen sign */
	float speed_mod; /** @brief global speed multiplier */
} dui_state_t;

/** @brief read and apply cmd to state */
void handle_cmd(unsigned char cmd, dui_state_t *state);
