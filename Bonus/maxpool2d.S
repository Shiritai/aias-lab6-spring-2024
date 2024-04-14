## maxpool2d.S

    .text                            # code section
    .global maxpool2d_asm            # declar the sum_asm function as a global function
    .type   maxpool2d_asm, @function # define maxpool2d_asm as a function

maxpool2d_asm:
# maxpool2d_c(
#const int8_t *input_X = a0
# int32_t input_X_dimW = a1
# int32_t input_X_dimH = a2
# int32_t input_X_dimC = a3
# int8_t *output_Y = a4
# int32_t kernel_WH = a5 -> kernel_H
# int32_t stride_WH = a6 -> stride_H
# )
# prologue: push stack
    addi    sp, sp, -52
    sw      ra, 0(sp)
    sw      s0, 4(sp)                # kernel_W
    sw      s1, 8(sp)                # stride_W
    sw      s2, 12(sp)               # h_out
    sw      s3, 16(sp)               # w_out
    sw      s4, 20(sp)               # square_sz
    sw      s5, 24(sp)               # out_square_sz
    sw      s6, 28(sp)               # c
    sw      s7, 32(sp)               # c_offset
    sw      s8, 36(sp)               # out_c_offset
    sw      s9, 40(sp)               # h
    sw      s10, 44(sp)              # w
    sw      s11, 48(sp)              # mx
# t0: h_offset
# t1: w_offset
# t2: kh
# t3: kw
# t4: h_idx -> idx -> position of input_X[idx] -> cur
# t5: w_idx -> o_idx -> position of output_Y[o_idx], then assign value

    srli    s0, a5, 16               # s0 = kernel_W
    li      t0, 0x0ffff
    and     a5, a5, t0               # a5 = kernel_H (mask with 0x0000ffff)

    srli    s1, a6, 16               # s1 = stride_W
    and     a6, a6, t0               # a5 = stride_H (mask with 0x0000ffff)

    sub     s2, a2, a5
    div     s2, s2, a6
    addi    s2, s2, 1                # s2 = h_out

    sub     s3, a1, s0
    div     s3, s3, s1
    addi    s3, s3, 1                # s3 = w_out

    mul     s4, a1, a2               # s4 = square_sz
    mul     s5, s2, s3               # s4 = out_square_sz

# for (int c = 0; c < input_X_dimC; ++c) {
    li      s6, 0                    # c = 0
loopC:
    beq     s6, a3, endLoopC         # if c == input_X_dimC, end
    mul     s7, s4, s6               # s7 = c_offset
    mul     s8, s5, s6               # s8 = out_c_offset

# for (int h = 0; h < h_out; ++h) {
    li      s9, 0                    # h = 0
loopH:
    beq     s9, s2, endLoopH         # if h == h_out, end

# for (int w = 0; w < w_out; ++w) {
    li      s10, 0                   # w = 0
loopW:
    beq     s10, s3, endLoopW        # if w == w_out, end

    li      s11, 0                   # mx = 0
    mul     t0, a6, s9               # t0 = h_offset
    mul     t1, s1, s10              # t1 = w_offset

    li      t2, 0                    # kh = 0
loopKH:
    beq     t2, a5, endLoopKH        # if kh == kernel_H, end

    li      t3, 0                    # kw = 0
loopKW:
    beq     t3, s0, endLoopKW        # if kw == kernel_W, end

    add     t4, t0, t2               # t4 = h_idx
    add     t5, t1, t3               # t5 = w_idx

    mul     t4, t4, a1               # h_idx * input_X_dimW
    add     t4, t4, t5               # h_idx * input_X_dimW + w_idx
    add     t4, t4, s7               # idx = h_idx * input_X_dimW + w_idx + c_offset
    add     t4, t4, a0               # position of input_X[idx]
    lb      t4, 0(t4)                # t4 = cur = input_X[idx]

# get max using branching
    bge     s11, t4, noMaxChange     # if mx > cur -> no change
    mv      s11, t4                  # otherwise, mx = cur
noMaxChange:
    addi    t3, t3, 1                # kw++
    j       loopKW

endLoopKW:
    addi    t2, t2, 1                # kh++
    j       loopKH

endLoopKH:
# store local max
    mul     t5, s9, s3               # h * w_out
    add     t5, t5, s10              # h * w_out + w
    add     t5, t5, s8               # o_idx = h * w_out + w + out_c_offset
    add     t5, t5, a4               # position of outputY[o_idx]
    sb      s11, 0(t5)               # outputY[o_idx] = mx

    addi    s10, s10, 1              # w++
    j       loopW

endLoopW:
    addi    s9, s9, 1                # h++
    j       loopH

endLoopH:
    addi    s6, s6, 1                # c++
    j       loopC

endLoopC:
# epilogue: pop stack
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    lw      s4, 20(sp)
    lw      s5, 24(sp)
    lw      s6, 28(sp)
    lw      s7, 32(sp)
    lw      s8, 36(sp)
    lw      s9, 40(sp)
    lw      s10, 44(sp)
    lw      s11, 48(sp)
    addi    sp, sp, 52
    ret

    .size   maxpool2d_asm, .-maxpool2d_asm