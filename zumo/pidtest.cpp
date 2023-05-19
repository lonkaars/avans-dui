#include <cstdio>
#include <random>

#include "pid.h"

std::random_device rd;
std::mt19937 rng(rd());
std::uniform_real_distribution<float> uni(0,13);

auto random_integer = uni(rng);

int main() {
	float P, I, D;
	do {
		// P = uni(rng);
		// I = uni(rng);
		// D = uni(rng);
		P = 10;
		I = 0.1;
		D = 10;
		PID test(P, I, D);
		test.reset(0.0);

		float val = 0;
		for (unsigned int i = 0; i < 100; i++) val = test.iter(1.0);
		// if (val > 0.999 && val < 1.001) {
			fprintf(stderr, "P: %.3f :: I: %.3f :: D: %.3f\n", P, I, D);
			test.reset(0.0);
			for (unsigned int i = 0; i < 100; i++) {
				printf("%2.8f\n", test.iter(1.0));
			}
			exit(0);
		// }
	} while (false);
}
