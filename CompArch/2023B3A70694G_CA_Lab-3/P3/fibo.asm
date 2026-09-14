.data
inputPrompt:     .asciiz "Enter a number: "
notFibonacci:     .asciiz "The number is not a Fibonacci number.\n"
isFibonacci:      .asciiz "The number is a Fibonacci number and its position is: "
newline:    .asciiz "\n"

.text
main:
    li   $v0, 4
    la   $a0, inputPrompt
    syscall

    li   $v0, 5
    syscall
    move $t0, $v0

    li   $t1, 0
    li   $t2, 1
    li   $t3, 0

    beq  $t0, $t1, found
    beq  $t0, $t2, found

fib_loop:
    add  $t4, $t1, $t2
    addi $t3, $t3, 1
    move $t1, $t2
    move $t2, $t4

    beq  $t0, $t4, found
    blt  $t0, $t4, notfound
    j    fib_loop

found:
    li   $v0, 4
    la   $a0, isFibonacci
    syscall
    
    addi $t3, $t3, 1
    li   $v0, 1
    move $a0, $t3
    syscall

    li   $v0, 4
    la   $a0, newline
    syscall
    j    exit

notfound:
    li   $v0, 4
    la   $a0, notFibonacci
    syscall
    j    exit

exit:
    li   $v0, 10
    syscall