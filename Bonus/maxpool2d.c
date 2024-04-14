#include "maxpool2d.h"
#include "util.h"

void maxpool2d_c(const int8_t *input_X, int32_t input_X_dimW,
                 int32_t input_X_dimH, int32_t input_X_dimC, int8_t *output_Y,
                 int32_t kernel_W, int32_t kernel_H, int32_t stride_W,
                 int32_t stride_H) {
  const int h_out = (input_X_dimH - kernel_H) / stride_H + 1;
  const int w_out = (input_X_dimW - kernel_W) / stride_W + 1;
  const int square_sz = input_X_dimH * input_X_dimW;
  const int out_square_sz = h_out * w_out;
  for (int c = 0; c < input_X_dimC; ++c) {
    const int c_offset = square_sz * c;
    const int out_c_offset = out_square_sz * c;
    for (int h = 0; h < h_out; ++h) {
      for (int w = 0; w < w_out; ++w) {
        int mx = 0;
        const int h_offset = stride_H * h;
        const int w_offset = stride_W * w;
        for (int kh = 0; kh < kernel_H; ++kh) {
          for (int kw = 0; kw < kernel_W; ++kw) {
            const int h_idx = h_offset + kh;
            const int w_idx = w_offset + kw;
            const int idx = h_idx * input_X_dimW + w_idx + c_offset;

            int8_t cur = input_X[idx];
            print_debug_msg("%d,\t", cur);
            /**
             * @brief Bitwise hack to find max of two numbers
             * ref:
             * http://graphics.stanford.edu/~seander/bithacks.html#IntegerMinOrMax
             */
            mx = mx ^ ((mx ^ cur) & -(mx < cur)); // max(mx, cur)
          }
        }
        print_debug_msg(" --> %d\n", mx);
        int o_idx = h * w_out + w + out_c_offset;
        output_Y[o_idx] = mx;
      }
    }
  }
}