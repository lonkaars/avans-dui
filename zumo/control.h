#pragma once

#include "protocol.h"

#define DUI_PINOUT_NICLA_TX 13
#define DUI_PINOUT_NICLA_RX 14

/** @brief non blocking read byte */
unsigned char uart_read();
/** @brief apply state to motors */
void apply_state(dui_state_t* state);

