// Lab3 - example_1_main.c

#include <stdio.h>
#include <stdlib.h>

int sum_c(int n){
  int temp = 0;
  for (int i = 1; i <= n; i++) {
    temp = temp + i;
  }
  return temp;
}

int puts(const char *msg);

int sum_ex1_asm(int n);

int sum_ex1_asm_wrong(int n);

int main(){
  int n = 5;
  int out = 0;
  out = sum_c(n);
  char str[25];
  itoa(out,str,10);
  puts("C code sum_c=");
  puts(str);
  puts("\n");
  out = sum_ex1_asm_wrong(n);
  puts("ASM code sum_ex1_asm=");
  itoa(out,str,10);
  puts(str);
  puts("\n");
  return 0;
}
