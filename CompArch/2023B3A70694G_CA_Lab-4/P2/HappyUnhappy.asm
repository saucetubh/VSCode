.data
input_prompt:  .asciiz "Enter a positive integer: "
happy_out:     .asciiz "This number is happy.\n"
unhappy_out:   .asciiz "The number is unhappy.\n"

.text
main:
    # print prompt
    la   $a0, input_prompt
    li   $v0, 4
    syscall

    # read integer N
    li   $v0, 5
    syscall
    move $s0, $v0

init_counter:
    li   $s1, 50

loop_start:
    li   $t0, 1
    beq  $s0, $t0, is_happy

    move $t3, $s0
    li   $t1, 0

sum_digits_loop:
    beq  $t3, $zero, sum_done
    li   $t2, 10
    divu $t3, $t2
    mfhi $t4
    mflo $t3
    mul  $t5, $t4, $t4
    addu $t1, $t1, $t5
    j    sum_digits_loop

sum_done:
    move $s0, $t1
    beq  $s0, $t0, is_happy
    addi $s1, $s1, -1
    blez $s1, is_unhappy
    j    loop_start

is_happy:
    la   $a0, happy_out
    li   $v0, 4
    syscall
    j    exit

is_unhappy:
    la   $a0, unhappy_out
    li   $v0, 4
    syscall
    j    exit

exit:
    li   $v0, 10
    syscall