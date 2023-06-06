#include <cstdio>
#include <random>

#include "../pid.h"

int main() {
	float P, I, D;
	P = -0.02;
	I = 0.13;
	D = -300;
	PID test(P, I, D);
	test.reset(0.0);

	fprintf(stderr, "P: %.3f :: I: %.3f :: D: %.3f\n", P, I, D);
	for (unsigned int i = 0; i < 100; i++) {
		printf("%2.8f\n", test.iter(i < 50 ? 1.0 : 0.0));
	}
}
