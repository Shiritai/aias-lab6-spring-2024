## Lab3 - example_1_sum.S
    .text                        # code section
    .global sum_ex1_asm          # declar the sum_asm function as a  global function
    .type sum_ex1_asm, @function # define sum_asm as a function
sum_ex1_asm:
prologue :
    addi sp,sp, -16
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    li s0,1
    mv s1,a0
    mv s2,zero
loop_start :
    bgt s0,s1,loop_end
    mv a0,s0
    add s2,s2,a0
    addi s0,s0,1
    j loop_start
loop_end :
    mv a0,s2

epilogue :
    lw ra,0(sp)
    lw s0,4(sp)
    lw s1,8(sp)
    lw s2,12(sp)
    addi sp,sp,16
    jr ra

    .size sum_ex1_asm, .-sum_ex1_asm