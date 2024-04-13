// main.c
#include "sudoku_2x2_c.h"
#include <stdio.h>
#include <stdlib.h>
#define SIZE 16

char test_c_data[16] = {0, 0, 2, 0,
                        0, 0, 0, 4,
                        2, 3, 0, 0,
                        0, 4, 0, 0};

char test_asm_data[16] = {0, 0, 2, 0, 0, 0, 0, 4, 2, 3, 0, 0, 0, 4, 0, 0};

void print_meow() {
  puts("Meow\n");
  // fflush(stdout);
}

void print_val(int v) {
  char str[25];
  itoa(v, str, 10);
  puts("val: ");
  puts(str);
  puts("\n");
}

void print_single_result(char *ls) {
  char str[25];

  for (int i = 0; i < 4; ++i) {
    for (int j = 0; j < 4; ++j) {
      int n = *(ls + i * 4 + j);
      itoa(n, str, 10);
      puts(str);
      puts(" ");
    }
    puts("\n");
  }
  puts("\n");
}

void print_sudoku_result() {
  int i;
  puts("Output c & assembly function result\n");
  puts("c result :\n");
  print_single_result(test_c_data);

  puts("assembly result :\n");
  print_single_result(test_asm_data);

  int flag = 0;
  for (i = 0; i < SIZE; i++) {
    if (*(test_c_data + i) != *(test_asm_data + i)) {
      flag = 1;
      break;
    }
  }

  if (flag == 1) {
    puts("\nyour c & assembly got different result ... QQ ...\n");
  } else {
    puts("\n\nyour c & assembly got same result!\n");
  }
}

int sudoku_2x2_asm(char *test_asm_data); // TODO, sudoku_2x2_asm.S

int sudoku_2x2_c(char *test_c_data); // TODO, sudoku_2x2_c.S

int main() {
  // print_val(
  // );
  sudoku_2x2_c(test_c_data);
  print_val(sudoku_2x2_asm(test_asm_data));
  print_sudoku_result();
  return 0;
}