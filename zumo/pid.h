#pragma once

#include "protocol.h"

/** @brief edit `current` to be closer to `target` using PID controllers */
void apply_pid(dui_state_t* target, dui_state_t* current);

