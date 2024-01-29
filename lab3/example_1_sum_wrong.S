## Lab3 - example_1_sum_wrong.S

    .text                               # code section
    .global sum_ex1_asm_wrong           # declar the sum_asm function as a  global function
    .type sum_ex1_asm_wrong, @function        # define sum_asm as a function
sum_ex1_asm_wrong:
prologue :
    li s0,1                  # s0 -> int i
    mv s1,a0                 # s1 -> int n
    mv s2,zero               # s2 -> int temp
loop_start :
    bgt s0,s1,loop_end
    mv a0,s0
    add s2,s2,a0
    addi s0,s0,1
    j loop_start
loop_end :
    mv a0,s2

epilogue :
    jr ra

    .size sum_ex1_asm_wrong, .-sum_ex1_asm_wrong