#include "maxpool2d.h"
#include "util.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int print_matrix(int8_t *mx, int c, int h, int w) {
  char str[25];

  for (int _c = 0; _c < c; ++_c) {
    for (int _h = 0; _h < h; ++_h) {
      for (int _w = 0; _w < w; ++_w) {
        itoa(mx[_c * h * w + _h * w + _w], str, 10);
        puts(str);
        puts(" ");
      }
      puts("\n");
    }
    puts("\n");
  }
  puts("\n");
  // fflush(stdout);
}

int single_c_asm_random_test() {
  // srand(time(NULL));

  const int dim_limit = 10;
  const int stride_limit = 3;
  const int kernel_limit = 3;

  const int32_t max_input_X_dimH = 20;
  const int32_t max_input_X_dimW = 20;
  const int32_t max_input_X_dimC = 3;

  const int32_t input_X_dimH = rand() % dim_limit + 3;
  const int32_t input_X_dimW = rand() % dim_limit + 3;
  const int32_t input_X_dimC = rand() % 3 + 1;

  const int32_t stride_H = rand() % stride_limit + 1;
  const int32_t stride_W = rand() % stride_limit + 1;

  const int32_t kernel_H = rand() % kernel_limit + 1;
  const int32_t kernel_W = rand() % kernel_limit + 1;

  int8_t input[max_input_X_dimH * max_input_X_dimW * max_input_X_dimC];


  const int32_t square_sz = input_X_dimW * input_X_dimH;
  for (int c = 0; c < input_X_dimC; ++c) {
    for (int h = 0; h < input_X_dimH; ++h) {
      for (int w = 0; w < input_X_dimW; ++w) {
        int8_t rand_val = rand() % INT8_MAX;
        input[h * input_X_dimW + w + square_sz * c] = rand_val;
      }
    }
  }

  const int h_out = (input_X_dimH - kernel_H) / stride_H + 1;
  const int w_out = (input_X_dimW - kernel_W) / stride_W + 1;

  int8_t c_output[max_input_X_dimH * max_input_X_dimW * max_input_X_dimC];
  int8_t asm_output[max_input_X_dimH * max_input_X_dimW * max_input_X_dimC];

  maxpool2d_c(input, input_X_dimW, input_X_dimH, input_X_dimC, c_output,
              kernel_W, kernel_H, stride_W, stride_H);


  maxpool2d_asm(input, input_X_dimW, input_X_dimH, input_X_dimC, asm_output,
                (kernel_W << (sizeof(int32_t) * 4)) | kernel_H,
                (stride_W << (sizeof(int32_t) * 4)) | stride_H);

  int wa_cnt = 0;
  char str[25];

  const int32_t out_square_sz = h_out * w_out;
  for (int c = 0; c < input_X_dimC; ++c) {
    for (int h = 0; h < h_out; ++h) {
      for (int w = 0; w < w_out; ++w) {
        int idx = h * w_out + w + out_square_sz * c;
        if (c_output[idx] != asm_output[idx]) {
          puts("c: [");
          itoa(c_output[idx], str, 10);
          puts(str);
          puts("] != asm: [");
          itoa(asm_output[idx], str, 10);
          puts(str);
          puts("]\n");
          wa_cnt += 1;
        }
      }
    }
  }

  return wa_cnt;
}

int main() {
  const int tests = 100;
  int cnt = 0;
  for (int i = 0; i < tests; ++i) {
    cnt += single_c_asm_random_test();
  }
  char str[10];
  if (!cnt) {
    puts("Passed ");
    itoa(tests, str, 10);
    puts(str);
    puts(" random tests\n");
  } else {
    itoa(cnt, str, 10);
    puts(str);
    puts("WA within ");
    itoa(tests, str, 10);
    puts(str);
    puts(" random tests\n");
  }
}