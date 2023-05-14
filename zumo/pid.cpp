#include "pid.h"

class PID {
private:
	float A0, A1, A2;
	float error[3] = {0};
	float dt = 0.010;
	float output = 0;

public:
	PID(float P, float I, float D) {
		A0 = P + I*dt + D/dt;
		A1 = -P - 2*D/dt;
		A2 = D/dt;
	}

	// https://en.wikipedia.org/wiki/PID_controller#Pseudocode
	float iter(float current, float target) {
		error[2] = error[1];
		error[1] = error[0];
		error[0] = target - current;
		output = output + A0 * error[0] + A1 * error[1] + A2 * error[2];
		return output;
	}
};

PID speed_pid(0.1, 0.0, 0.0); // TODO: tune these (garbage values)
PID steer_pid(0.1, 0.0, 0.0);
PID speed_mod_pid(1, 1, 1);
void apply_pid(dui_state_t* target, dui_state_t* current) {
	current->speed = speed_pid.iter(current->speed, target->speed);
	current->steer = steer_pid.iter(current->steer, target->steer);
	// current->speed_mod = speed_mod_pid.iter(current->speed_mod, target->speed_mod);
	current->speed_mod = target->speed_mod;
}

