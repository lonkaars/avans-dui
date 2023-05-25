#pragma once

#include "protocol.h"

class PID {
private:
	float A0, A1, A0d, A1d, A2d, tau, alpha, d0, d1, fd0, fd1;
	float error[3];
	float output;
	const float dt = 1.0;
	const float N = 10.0;

public:
	PID(float P = -0.02, float I = 0.13, float D = -300.0);
	float iter(float target);
	void reset(float value);
};

/** @brief edit `current` to be closer to `target` using PID controllers */
void apply_pid(dui_state_t* target, dui_state_t* current);

