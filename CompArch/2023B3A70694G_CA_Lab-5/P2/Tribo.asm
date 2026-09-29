.data
header:       .asciiz "First 7 Tribonacci numbers: "
comma:        .asciiz ", "
newline:      .asciiz "\n"

.text
main:

    li   $t1, 0
    li   $t2, 1
    li   $t3, 1
    li   $t4, 0      


    li   $v0, 4
    la   $a0, header
    syscall

print_loop:
    beq  $t4, 7, exit

    li   $v0, 1
    move $a0, $t1
    syscall


    li   $v0, 4
    la   $a0, comma
    syscall

    addi $t4, $t4, 1


    add  $t5, $t1, $t2
    add  $t5, $t5, $t3

    move $t1, $t2
    move $t2, $t3
    move $t3, $t5

    j    print_loop

exit:
    li   $v0, 4
    la   $a0, newline
    syscall
    li   $v0, 10
    syscall