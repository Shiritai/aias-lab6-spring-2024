## fibonacci.S

    .text                          # code section 
    .global fibonacci_asm          # declar the sum_asm function as a  global function
    .type fibonacci_asm, @function # define sum_asm as a function 
fibonacci_asm:

    # Write your assembly code funtion here.
    # Please notice the rules of calling convention.
    
    .size fibonacci_asm, .-fibonacci_asm