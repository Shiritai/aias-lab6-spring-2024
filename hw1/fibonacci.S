## fibonacci.S
## put input n in register x10 (a0)
## put output fibonacci(n) in register x11 (a1)
## use Venus to test correctness

    .text
main:
## write assembly code here.
## call fibonacci function and get return value.
    li    a0, 16       # n = 16
    jal   fibonacci    # fib(16)

    addi  a0, x0, 1    # printf("%d\n, a1)
    ecall
    addi  a1, x0, '\n'
    addi  a0, x0, 11
    ecall

    addi  a0, x0, 10   # exit(0)
    ecall

fibonacci:
## fibonacci function
    mv    a1, a0       # if n == 0 or n == 1, return value is n and should be put at a1
    addi  t0, x0, 1
    ble   a1, t0, end  # if n <= 1 then end

recur:
    addi  sp, sp, -12  # initiate stack, -12 is for alignment
    sw    ra, 0(sp)    # push ra to stack
    sw    s0, 4(sp)    # push s0 to stack (save s0 before use)
    sw    s1, 8(sp)    # push s1 to stack (save s1 before use)

    mv    s0, a0       # s0 = n
    addi  a0, s0, -1   # reg a0: n - 1, as parameter of the next function call
    jal   fibonacci    # call fib(n - 1)
    mv    s1, a1       # save result of fib(n - 1) to s1

    addi  a0, s0, -2   # reg a0: n - 2, as parameter of the next function call
    jal   fibonacci    # call fib(n - 2)

    add   a1, s1, a1   # reg a1: fib(n - 1) + fib(n - 2), as return value

    lw    ra, 0(sp)    # load ra back
    lw    s0, 4(sp)    # load s0 back
    lw    s1, 8(sp)    # load s1 back
    addi  sp, sp, 12   # pop stack

end:
    jr    ra           # jump to ra