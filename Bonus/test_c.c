#include "maxpool2d.h"
#include "util.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int single_c_py_random_test() {
  srand(time(NULL));

  const int dim_limit = 50;
  const int stride_limit = 4;
  const int kernel_limit = 4;

  const int32_t input_X_dimH = rand() % dim_limit + 4;
  const int32_t input_X_dimW = rand() % dim_limit + 4;
  const int32_t input_X_dimC = rand() % 3 + 1;

  const int32_t stride_H = rand() % stride_limit + 1;
  const int32_t stride_W = rand() % stride_limit + 1;

  const int32_t kernel_H = rand() % kernel_limit + 1;
  const int32_t kernel_W = rand() % kernel_limit + 1;

  int8_t *input = (int8_t *)malloc(sizeof(int8_t) * input_X_dimH *
                                   input_X_dimW * input_X_dimC);

  // save array as file
  FILE *fp = fopen("Bonus/rand_input.txt", "w");
  fprintf(fp, "%d %d %d\n", input_X_dimC, input_X_dimH, input_X_dimW);
  fprintf(fp, "%d %d\n", stride_H, stride_W);
  fprintf(fp, "%d %d\n", kernel_H, kernel_W);
  print_debug_msg("input: %d %d %d\n", input_X_dimC, input_X_dimH,
                  input_X_dimW);
  print_debug_msg("stride: %d %d\n", stride_H, stride_W);
  print_debug_msg("kernel: %d %d\n", kernel_H, kernel_W);
  fprintf(fp, "[ ");

  const int32_t square_sz = input_X_dimW * input_X_dimH;
  for (int c = 0; c < input_X_dimC; ++c) {
    for (int h = 0; h < input_X_dimH; ++h) {
      print_debug_msg("%c%c[", c == 0 && h == 0 ? '[' : ' ',
                      h == 0 ? '[' : ' ');
      for (int w = 0; w < input_X_dimW; ++w) {
        int8_t rand_val = rand() % INT8_MAX;
        input[h * input_X_dimW + w + square_sz * c] = rand_val;
        fprintf(fp, "%d, ", rand_val);
        print_debug_msg("%d,\t", rand_val);
      }
      print_debug_msg("]%c", h + 1 < input_X_dimH ? '\n' : ',');
    }
    print_debug_msg("]\n");
  }
  print_debug_msg("]\n");

  fprintf(fp, " ]");
  fclose(fp);

  const int h_out = (input_X_dimH - kernel_H) / stride_H + 1;
  const int w_out = (input_X_dimW - kernel_W) / stride_W + 1;
  int8_t *output =
      (int8_t *)malloc(sizeof(int8_t) * h_out * w_out * input_X_dimC);

  maxpool2d_c(input, input_X_dimW, input_X_dimH, input_X_dimC, output, kernel_W,
              kernel_H, stride_W, stride_H);

  fp = fopen("Bonus/c_output.txt", "w"); // also save array as file

  const int32_t out_square_sz = h_out * w_out;
  for (int c = 0; c < input_X_dimC; ++c) {
    for (int h = 0; h < h_out; ++h) {
      for (int w = 0; w < w_out; ++w) {
        fprintf(fp, "%d\n", output[h * w_out + w + out_square_sz * c]);
      }
    }
  }
  fclose(fp);

#ifdef DEBUG_MODE
  system("python3 Bonus/maxpool.py -d");
#else
  system("python3 Bonus/maxpool.py");
#endif
  system("command -v colordiff > /dev/null || (sudo apt update && sudo apt "
         "install "
         "colordiff)");
  /**
   * if no output, then everything works fine :)
   */
  int res = system("colordiff Bonus/c_output.txt Bonus/py_output.txt");

  free(input);
  free(output);

  return res;
}

void maxpool_c_py_test() {
  const int tests = 20;
  int cnt = 0;
  for (int i = 0; i < tests; ++i) {
    cnt += single_c_py_random_test();
  }
  if (!cnt) {
    printf("Passed %d random tests\n", tests);
  } else {
    printf("%d WA within %d random tests\n", cnt, tests);
  }
}

int main() {
  maxpool_c_py_test();
}