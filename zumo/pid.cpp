#include "pid.h"

PID::PID(float P, float I, float D) {
	A0 = P + I*dt + D/dt;
	A1 = -P - 2*D/dt;
	A2 = D/dt;
}

// https://en.wikipedia.org/wiki/PID_controller#Pseudocode
float PID::iter(float target) {
	error[2] = error[1];
	error[1] = error[0];
	error[0] = target - output;
	output = output + A0 * error[0] + A1 * error[1] + A2 * error[2];
	return output;
}

void PID::reset(float value) {
	error[0] = 0.0;
	error[1] = 0.0;
	error[2] = 0.0;
	output = value;
}

PID speed_pid(0.1, 0.0, 0.0); // TODO: tune these (garbage values)
PID steer_pid(0.1, 0.0, 0.0);
PID speed_mod_pid(1, 1, 1);
void apply_pid(dui_state_t* target, dui_state_t* current) {
	current->speed = speed_pid.iter(target->speed);
	current->steer = steer_pid.iter(target->steer);
	// current->speed_mod = speed_mod_pid.iter(current->speed_mod, target->speed_mod);
	current->speed_mod = target->speed_mod;
}

