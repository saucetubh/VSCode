.data
	
.text
	main:				
		addi $s0, $zero, 4 
		addi $s1, $zero, 10
		addi $s2, $zero, 12
		
		#index $t0
		addi $t0, $zero, 0
		
		#store the data into the array
		sw $s0, myArray($t1)
		addi $t4, $t0, 4
		sw $s1, myArray($t2)
		addi $t5, $t0, 4
		sw $s2, myArray($t3)
		
		#loading the value from the array to register t6
		lw $t6, myArray($zero)
		
		li $v0, 1
		addi $a0, $t6, 0
		syscall
		
		#end of main
		li $v1, 10
		syscall
	
		
		
		