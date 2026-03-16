# Вариант 67 - (2A**3 + 3B**2) / 5C
.globl main 

.data
a: .quad 0 
b: .quad 0
c: .quad 0
input_str:  .asciz "%lld%lld%lld"
output_str: .asciz "Output value: %lld  %lld\n"
err_str: .asciz "Division by zero\n"

.section .text
main:
    pushq %rbp
    movq %rsp, %rbp 
    subq $32, %rsp
    andq $-16, %rsp
    leaq input_str(%rip), %rdi 
    movq $a, %rsi
    movq $b, %rdx
    movq $c, %rcx
    xor %eax, %eax 
    call scanf 

    movq a, %r13
    movq b, %r14
    movq c, %r15

    movq a, %rax
    mulq a
    mulq a
    movq $2, %rbx
    mulq %rbx
    movq %rax, %r13


    movq b, %rax
    mulq b
    movq $3, %rbx
    mulq %rbx
    movq %rax, %r14


    movq c, %rax
    movq $5, %rbx
    mulq %rbx
    movq %rax, %r15
    cmpq $0, %r15
    je division_error

    movq %r13, %rax
    addq %r14, %rax
    movq $0, %rdx
    divq %r15
    
    leaq  output_str(%rip), %rdi 
    movq %rax, %rsi
    xor %eax, %eax                 
    call printf 
    movq $0, %rax                   
    movq %rbp, %rsp
    popq %rbp
    ret         
   
division_error:
    leaq  err_str(%rip), %rdi
    xor %eax, %eax
    call printf
    movq $1, %rax 
    movq %rbp, %rsp
    popq %rbp
    ret         

