#include "pid.h"

PID::PID(float P, float I, float D) {
	A0 = P + I * dt;
	A1 = -P;
	A0d = D / dt;
	A1d = -2 * D / dt;
	A2d = D / dt;
	tau = D / (P * N);
	alpha = dt / (2 * tau);
	reset(0.0);
}

// https://en.wikipedia.org/wiki/PID_controller#Pseudocode
float PID::iter(float target) {
	error[2] = error[1];
	error[1] = error[0];
	error[0] = target - output;

	output = output + A0 * error[0] + A1 * error[1];

	d1 = d0;
	d0 = A0d * error[0] + A1d * error[1] + A2d * error[2];
	fd1 = fd0;
	fd0 = ((alpha) / (alpha + 1)) * (d0 + d1) - ((alpha - 1) / (alpha + 1)) * fd1;
	output = output + fd0;

	if (output < -1) output = -1;
	if (output > 1) output = 1;
	return output;
}

void PID::reset(float value) {
	error[0] = 0.0;
	error[1] = 0.0;
	error[2] = 0.0;
	d0 = 0;
	d1 = 0;
	fd0 = 0;
	fd1 = 0;
	output = value;
}

PID speed_pid = PID();
PID steer_pid = PID();
PID speed_mod_pid = PID();
void apply_pid(dui_state_t* target, dui_state_t* current) {
	current->speed = speed_pid.iter(target->speed);
	current->steer = steer_pid.iter(target->steer);
	current->speed_mod = speed_mod_pid.iter(target->speed_mod);
}

