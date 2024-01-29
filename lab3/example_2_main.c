// Lab3 example_2_main.c

#include <stdio.h>
#include <stdlib.h>

int formula(int n){
  return (1+n)*n/2;
}

int sum_c(int n){
  return formula(n);
}

int sum_ex2_asm(int n);

int main(){
  int n = 5;
  int out = 0;
  out = sum_c(n);
  char str[25];
  itoa(out,str,10);
  puts("C code sum_c=");
  puts(str);
  puts("\n");
  out = sum_ex2_asm(n);
  puts("ASM code sum_ex2_asm=");
  itoa(out,str,10);
  puts(str);
  puts("\n");
  return 0;
}