# sudoku_2x2_asm.S

    .text                                    # code section
    .global sudoku_2x2_asm                   # declare the asm function as a global function
    .type   sudoku_2x2_asm, @function        # define sudoku_2x2_asm as a function

sudoku_2x2_asm:

# solve(idx = 0)
# prologue: push stack
    addi    sp, sp, -20
    sw      ra, 0(sp)
    sw      s8, 4(sp)                        # will be use as global constant
    sw      s9, 8(sp)                        # will be use as global constant
    sw      s10, 12(sp)                      # will be use as global constant
    sw      s11, 16(sp)                      # will be use as global constant

# setup global variables for the whole
# recursive call to temperal registers
    mv      s8, a0                           # s8 = ls (char array)
    li      s9, 2                            # s9 (box_width) = 2
    li      s10, 4                           # s10 (side_lim) = 4
    li      s11, 16                          # s11 (bound) = 16

# funciton call
    mv      a0, x0                           # start to "solve" from index 0
    jal     solve
# epilogue: pop stack
    lw      ra, 0(sp)
    lw      s8, 4(sp)
    lw      s9, 8(sp)
    lw      s10, 12(sp)
    lw      s11, 16(sp)
    addi    sp, sp, 20
    ret

    # .size   sudoku_2x2_asm, .-sudoku_2x2_asm

check_and_mark: # check_and_mark(shift)
    li      t0, 1
    sll     t0, t0, a0                       # int hot = 1 << shift

# # prologue for all function calls
#     addi    sp, sp, -4
#     sw      ra, 0(sp)
#     jal     print_val
# # epilogue: before return, pop stack
#     lw      ra, 0(sp)
#     addi    sp, sp, 4

    beq     a0, x0, check_and_mark_ret_true  # if shift == 0, return true
    and     t1, s0, t0                       # t1 = tb & hot
    beq     t1, x0, check_and_mark_ret_true  # (tb & hot) == 0, no overlap --> return true

    li      a0, 0                            # return valuie: false
    ret

check_and_mark_ret_true:
# # prologue for all function calls
#     addi    sp, sp, -4
#     sw      ra, 0(sp)
#     jal     print_meow
# # epilogue: before return, pop stack
#     lw      ra, 0(sp)
#     addi    sp, sp, 4

    or      s0, s0, t0                       # tb = tb | hot, i.e. mark table
    li      a0, 1                            # return valuie: true
    ret

check: # check(a0 = idx)
# prologue for all function calls
    addi    sp, sp, -28
    sw      ra, 0(sp)
    sw      s0, 4(sp)                        # will be used as tb, used as a shared register between check and check_and_mark
    sw      s1, 8(sp)                        # will be used as x and baseX
    sw      s2, 12(sp)                       # will be used as y and baseY
    sw      s3, 16(sp)                       # will be used as iterator (or i in nested loop)
    sw      s4, 20(sp)                       # will be used as iterator limit (or j in nested loop)
    sw      s5, 24(sp)                       # will be used as offset in nested loop

    rem     s1, a0, s10                      # int x = idx % side_lim
    div     s2, a0, s10                      # int y = idx / side_lim

# horizontal scan by fixing y (in single dimension version)
    mul     s3, s2, s10                      # int base = y * side_lim
    add     s4, s3, s10                      # let s4 as iteration limit = base + side_lim
    li      s0, 0                            # tb = 0 (initialize mark table)
check_h_loop: # loop for horizontal scanning
    add     a0, s8, s3                       # a0 = position of ls[i]
    lb      a0, 0(a0)                        # a0 = ls[i]
    jal     check_and_mark                   # check_and_mark(shift = ls[i])
    beq     a0, x0, check_ret_false          # if check_and_mark returns false, then check_ret_false
# mv a0, s0
# jal print_val

    addi    s3, s3, 1                        # i++
# mv a0, s3
# jal print_val
    blt     s3, s4, check_h_loop             # if i < base + side_lim then check_h_loop

# # vertical scan by fixing x
    mv      s3, s1                           # int base = x
    mv      s4, s11                          # let s4 as iteration limit = bound
    li      s0, 0                            # tb = 0 (initialize mark table)
check_v_loop: # loop for vertical scanning
    add     a0, s8, s3                       # a0 = position of ls[i]
    lb      a0, 0(a0)                        # a0 = ls[i]
    jal     check_and_mark                   # check_and_mark(shift = ls[i])
    beq     a0, x0, check_ret_false          # if check_and_mark returns false, then check_ret_false

    add     s3, s3, s10                      # i += side_lim
    blt     s3, s4, check_v_loop             # if i < bound then check_v_loop

# # box scan by indirect index mapping
# div s1, s1, s9 # s1 = x / box_width
# mul s1, s1, s9 # int baseX = (x / box_width) * box_width
# div s2, s2, s9 # s2 = y / box_width
# mul s2, s2, s9 # int baseY = (y / box_width) * box_width
# li s0, 0 # tb = 0 (initialize mark table)
# # for (int i = 0; i < box_width; ++i)
# li s3, 0 # i = 0
# check_b_first_loop: # first loop for box scanning
# add s5, s3, s2 # s5 = i + baseY
# mul s5, s5, s10 # s5 = (i + baseY) * side_lim
# add s5, s5, s1 # offset = (i + baseY) * side_lim + baseX

# # for (int j = 0; j < box_width; ++j)
# li s4, 0 # j = 0
# check_b_second_loop: # second loop for box scanning

# # jal print_meow # debug
# mv a0, s8

# add a0, s8, s5 # a0 = ls + offset
# add a0, a0, s4 # a0 = position of ls[offset + j]
# lb a0, 0(a0) # a0 = ls[i]
# jal check_and_mark # check_and_mark(shift = ls[i])
# beq a0, x0, check_ret_false # if check_and_mark returns false, then check_ret_false

# addi s4, s4, 1 # j++
# blt s4, s9, check_b_second_loop # if j < box_width then check_b_second_loop
# # end of j for loop

# addi s3, s3, 1 # i++
# blt s3, s9, check_b_first_loop # if i < box_width then check_b_first_loop
# # end of i for loop

# jal print_meow
    li      a0, 1                            # return value: true
# epilogue: before return, pop stack
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    lw      s4, 20(sp)
    lw      s5, 24(sp)
    addi    sp, sp, 28
    ret

check_ret_false:
# jal print_meow
    li      a0, 0                            # return value: false
# epilogue: before return, pop stack
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    lw      s4, 20(sp)
    lw      s5, 24(sp)
    addi    sp, sp, 28
    ret

solve: # solve(a0 = idx)
    beq     a0, s11, solve_ret_true          # if (idx == bound) return true
# prologue for all function calls: push stack
    addi    sp, sp, -12
    sw      ra, 0(sp)
    sw      s0, 4(sp)                        # we need s0 as current idx (a0)
    sw      s1, 8(sp)                        # we need s1 as n in loop

    mv      s0, a0                           # s0 = idx

    add     t0, s8, s0                       # t0 = address of ls[idx]
    lb      t1, 0(t0)                        # t1 = ls[idx]
    bne     t1, x0, call_solve_nxt_and_ret   # if ls[idx] > 0, then call_solve_nxt_and_ret
# for loop
    li      s1, 1                            # for n = 1
loop:
    sb      s1, 0(t0)                        # ls[idx] = n
# lb a0, 0(t0) # ls[idx] = n
# jal print_val

    mv      a0, s0                           # a0 = idx
    jal     check                            # check(idx)

    beq     a0, x0, to_nxt_loop              # if check returns invalid, then prepare next loop
# solve(idx = idx + 1)
    addi    a0, s0, 1                        # a0 = idx + 1
    jal     solve
    bne     a0, x0, solve_epilogue_ret_true  # if recursive solve returns valid, then returns true
to_nxt_loop:
    addi    s1, s1, 1                        # n += 1
    bgt     s1, s10, end_loop                # if n > side_lim (4), end loop
    j       loop
end_loop:
    add     t0, s8, s0                       # address of ls[idx]
    sb      x0, 0(t0)                        # ls[idx] = 0
    j       solve_epilogue_ret_false         # return false

call_solve_nxt_and_ret:
# solve(idx = idx + 1)
# funciton call
    addi    a0, s0, 1                        # a0 = idx + 1
    jal     solve
# epilogue: before return, pop stack
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    addi    sp, sp, 12
# return a0 = solve(idx = idx + 1)
    ret

solve_epilogue_ret_true:
# epilogue: before return, pop stack
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    addi    sp, sp, 12

solve_ret_true:
    li      a0, 1                            # a0 = true
    ret

solve_epilogue_ret_false:
    li      a0, 0                            # a0 = false
# epilogue: before return, pop stack
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    addi    sp, sp, 12
    ret

    # .size   sudoku_2x2_asm, .-sudoku_2x2_asm