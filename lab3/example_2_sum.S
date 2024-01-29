## Lab3 - example_2_sum.S

    .text                        # code section
    .global sum_ex2_asm          # declar the sum_asm function as a  global function
    .type sum_ex2_asm, @function # define sum_asm as a function
sum_ex2_asm:
prologue :
    addi sp,sp,-4
    sw   ra,0(sp)

funct_start :
    jal  formula

epilogue :
    lw   ra,0(sp)
    addi sp,sp,4
    jr   ra

formula :
    mv   t0,a0
    li   t1,1
    li   t2,2
    add  t1,t0,t1
    mul  t1,t0,t1
    div  t1,t1,t2
    mv   a0,t1
    jr   ra

    .size sum_ex2_asm, .-sum_ex2_asm