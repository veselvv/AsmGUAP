# Вариант 67 - (6A**2-5A+10)/12
.globl main 

.data
a: .quad 0 

input_str:  .asciz "%lld"
output_str: .asciz "Output value: %lld  %lld\n"


.section .text
main:
    pushq %rbp
    movq %rsp, %rbp 
    subq $32, %rsp
    andq $-16, %rsp
    leaq input_str(%rip), %rdi 
    movq $a, %rsi
    xor %eax, %eax 
    call scanf 

    movq a, %r13
    movq a, %rax
    imulq a
    movq $6, %rbx
    imulq %rbx
    movq %rax, %r14
    movq a, %rax
    movq $5, %rbx
    imulq %rbx
    movq %rax, %r15
    subq %r15, %r14
    addq $10, %r14
    movq %r14, %rax
    movq $12, %rbx  
    cqo
    idivq %rbx
    
    leaq  output_str(%rip), %rdi 
    movq %rax, %rsi 
    xor %eax, %eax                 
    call printf 
    movq $0, %rax                   
    movq %rbp, %rsp
    popq %rbp
    ret         
   
