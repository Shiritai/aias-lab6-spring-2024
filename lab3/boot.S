.align 4
.equ UART_REG_TXFIFO,   0
.equ UART_BASE,         0x10000000

.section .text
.global _start
.global puts

_start:
    csrr  t0, mhartid             # read hardware thread id (`hart` stands for `hardware thread`)
    bnez  t0, halt                # run only on the first hardware thread (hartid == 0), halt all the other threads

    la    sp, stack_top           # setup stack pointer

main_entry:
	# jump to main program entry point (argc = argv = 0) 
  	addi x10, x0, 0
  	addi x11, x0, 0
  	jal x1, main

    la    a0, msg                 # load address of `msg` to a0 argument register
    jal   puts                    # jump to `puts` subroutine, return address is stored in ra regster

halt:   
    j     halt                     # enter the infinite loop

puts:                                 
    # `puts` subroutine writes null-terminated string to UART (serial communication port)
    # input: a0 register specifies the starting address of a null-terminated string
    # clobbers: t0, t1, t2 temporary registers

    li    t0, UART_BASE           # t0 = UART_BASE
uart_print:      
    lbu   t1, (a0)       # t1 = load unsigned byte from memory address specified by a0 register
    beqz  t1, uart_end   # break the loop, if loaded byte was null

    # wait until UART is ready
positive:      
    lw    t2, UART_REG_TXFIFO(t0) # t2 = uart[UART_REG_TXFIFO]
    bltz  t2, positive            # t2 becomes positive once UART is ready for transmission
    sw    t1, UART_REG_TXFIFO(t0) # send byte, uart[UART_REG_TXFIFO] = t1

    addi  a0, a0, 1               # increment a0 address by 1 byte
    j     uart_print

uart_end:      
    ret


.section .rodata
msg:
     .string "Baremetal code runs to the end. (pressing `ctrl+a x` to quit)\n"