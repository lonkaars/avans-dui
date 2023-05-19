#pragma once

#include "protocol.h"

class PID {
private:
	float A0, A1, A2;
	float error[3] = {0};
	float dt = 0.010;
	float output = 0;

public:
	PID(float P, float I, float D);
	float iter(float target);
	void reset(float value);
};

/** @brief edit `current` to be closer to `target` using PID controllers */
void apply_pid(dui_state_t* target, dui_state_t* current);

