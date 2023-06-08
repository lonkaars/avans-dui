#include <cstdio>

#include "../protocol.h"

int main() {
	for (unsigned int i = 0; i < 15; i++) {
		if (DUI_SIGN_LOOKUP[i] == NULL) continue;
		printf("%d: %s\n", i, DUI_SIGN_LOOKUP[i]);
	}
}
