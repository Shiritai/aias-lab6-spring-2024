#ifndef MAXPOOL2D_H
#define MAXPOOL2D_H

#include <stdint.h>

void maxpool2d_c(const int8_t *input_X, int32_t input_X_dimW,
                 int32_t input_X_dimH, int32_t input_X_dimC, int8_t *output_Y,
                 int32_t kernel_W, int32_t kernel_H, int32_t stride_W,
                 int32_t stride_H);

void maxpool2d_asm(const int8_t *input_X, int32_t input_X_dimW,
                   int32_t input_X_dimH, int32_t input_X_dimC, int8_t *output_Y,
                   int32_t kernel_WH, int32_t stride_WH);

#endif /* MAXPOOL2D_H */