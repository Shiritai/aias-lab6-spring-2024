## fibonacci.S

    .text                                  # code section
    .global fibonacci_asm                  # declar the sum_asm function as a global function
    .type   fibonacci_asm, @function       # define sum_asm as a function

fibonacci_asm:
## fibonacci function
    addi    t0, x0, 1
    ble     a0, t0, end                    # if n <= 1 then end

recur:
    addi    sp, sp, -12                    # initiate stack, -12 is for alignment
    sw      ra, 0(sp)                      # push ra to stack
    sw      s0, 4(sp)                      # push s0 to stack (save s0 before use)
    sw      s1, 8(sp)                      # push s1 to stack (save s1 before use)

    mv      s0, a0                         # s0 = n
    addi    a0, s0, -1                     # reg a0: n - 1, as parameter of the next function call
    jal     fibonacci_asm                  # call fib(n - 1)
    mv      s1, a0                         # save result of fib(n - 1) to s1

    addi    a0, s0, -2                     # reg a0: n - 2, as parameter of the next function call
    jal     fibonacci_asm                  # call fib(n - 2)

    add     a0, s1, a0                     # reg a0: fib(n - 1) + fib(n - 2), as return value

    lw      ra, 0(sp)                      # load ra back
    lw      s0, 4(sp)                      # load s0 back
    lw      s1, 8(sp)                      # load s1 back
    addi    sp, sp, 12                     # pop stack

end:
    jr      ra                             # jump to ra

    .size   fibonacci_asm, .-fibonacci_asm