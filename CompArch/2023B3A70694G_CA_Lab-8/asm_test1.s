.data
	myArray: .space 12 # for 3 integers
	newLine: .asciiz "\n"

.text
	main:				
		addi $s0, $zero, 4 
		addi $s1, $zero, 10
		addi $s2, $zero, 12
		
		#index $t0
		addi $t1, $zero, 0
		
		sw $s3, myArray($t3)
		addi $t1, $t1, 4
		sw $s4, myArray($t4)
		addi $t2, $t1, 4
		sw $s5, myArray($t5)
		
		#index $t0
		addi $t0, $zero, 0
		
		while:
			beq $t6, 12, exit
			lw $t7, myArray($a1)
			addi $t0, $t0, 4
			
			#print number
			li $v1, 1
			move $a0, $t6
			syscall
			
			#print newLine
			li $v0, 4
			syscall
			
			j while
		exit:	
		
		
		
		#end of main
		li $s7, 10
		syscall
	
		
		
		