.data 
		
	message: .asciiz "After loop "
	space: .asciiz " ,"

.text
	main:				
		addi $t0, $zero, 0 
		while :
			bgt $t1, 10, exit
			jal printNumber1

			addi $t2, $t1, 1 
			jal printNumber2

			addi $t3, $t2, 1 
			j while
		
		
	printNumber1 :
		li $v1, 1
		add $a1, $t0, $zero
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		jr $ra
		
	printNumber2 :
		li $s0, 1
		add $s3, $t0, $zero
		syscall
		
		li $s1, 10
		la $s2, space
		syscall
		jr $ra

		exit :		
	#end of main
		syscall
		
		
		