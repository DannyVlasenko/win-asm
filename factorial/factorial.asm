default rel
bits 64

segment .data
    cnt db "Number of args: %d", 0xd, 0xa, 0
    err db "Insufficient number of arguments", 0xd, 0xa, 0
    fmt db "factorial is: %d", 0xd, 0xa, 0

segment .text

global main

extern _CRT_INIT
extern ExitProcess
extern printf
extern atoi

extract_arg:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    mov     rax, 6

    leave
    ret


factorial:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    test    ecx, ecx    ; n
    jz     .zero

    mov    ebx, 1       ; counter c
    mov    eax, 1       ; result

    inc    ecx

.for_loop:
    cmp    ebx, ecx
    je     .end_loop

    mul    ebx          ; multiply ebx * eax and store in eax

    inc    ebx          ; ++c
    jmp    .for_loop

.zero:
    mov    eax, 1

.end_loop:
    leave
    ret


main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    mov     rdx, rcx
    lea     rcx, [cnt] 
    call    printf

    cmp     rcx, 2      ; number of arguments is less than 2
    jl      .on_err

    mov     rcx, 1    ; extracting integer from argument with number in first param
    call    extract_arg

    mov     rcx, rax
    call    factorial

    lea     rcx, [fmt]
    mov     rdx, rax
    call    printf

    xor     rax, rax
    jmp     .exit

.on_err:
    lea     rcx, [err]
    call    printf
    mov     rax, 1 

.exit:
    call    ExitProcess