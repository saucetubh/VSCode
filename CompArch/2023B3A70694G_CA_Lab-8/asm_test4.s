.data
	myArray: .word 100:3 
	newLine: .asciiz "\n"

.text
	main:				
				
		#index $t0
		addi $t0, $t0, 0
		
		while:
			beq $t1, 12, exit
			lw $t6, myArray($t2)
			addi $t3, $t0, 4
			
			#print number
			li $v0, 1
			move $a0, $t0
			addi $t4, $t6, 4
			syscall
			
			#print newLine
			li $v1, 4
			la $a1, newLine
			syscall
			
			j while
		exit:	
		
		
		
		#end of main
		li $v2, 10
		syscall
	
		
		
		