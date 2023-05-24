#include <cstdio>
#include <random>

#include "../protocol.h"

void print_state(dui_state_t* s) {
	printf("{ steer = %1.3f\n  speed = %1.3f }\n", s->steer, s->speed);
}

void test_case(unsigned char cmd, dui_state_t* s) {
	printf("\ncmd in = 0x%02x\n", cmd);
	handle_cmd(cmd, s);
	print_state(s);
}

int main() {
	dui_state_t state = {
		.steer = 0.f,
		.speed = 1.f,
		.current_sign = DUI_SIGN_NONE,
		.speed_mod = 1.f,
	};

	test_case(0x00, &state);
	test_case(0x01, &state);
	test_case(0x02, &state);
	test_case(0x10, &state);
	test_case(0x15, &state);
	test_case(0x1f, &state);
	test_case(0x20, &state);
	test_case(0x25, &state);
	test_case(0x2f, &state);
	test_case(0x88, &state);
	test_case(0xff, &state);
}
