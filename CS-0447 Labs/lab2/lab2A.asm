.data
prompt1: .asciiz "What is the first value? "
.text
	addi $v0, $zero, 4	#print first statement
	la $a0, prompt1
	syscall

	addi $v0, $zero, 5	#read in first value
	syscall
	add $s2, $zero, $v0
	
.data
prompt2: .asciiz "What is the second value? "

.text
	addi $v0, $zero, 4	#print second statement
	la $a0, prompt2
	syscall
	
	addi $v0, $zero, 5	#read in second value
	syscall
	add $s3, $zero, $v0
	
	add $s4, $s2, $s3	#add first & second value
	
.data
promptTotal1: .asciiz "The sum of "

.text
	addi $v0, $zero, 4	#print total statement
	la $a0, promptTotal1
	syscall
	
	addi $v0, $zero, 1	#print first value
	add $a0, $zero, $s2
	syscall
	
.data
promptTotal2: .asciiz " and "

.text
	addi $v0, $zero, 4	#print total statement
	la $a0, promptTotal2
	syscall
	
	addi $v0, $zero, 1	#print second value
	add $a0, $zero, $s3
	syscall
	
.data
promptTotal3: .asciiz " is "

.text
	addi $v0, $zero, 4	#print total statement
	la $a0, promptTotal3
	syscall
	
	addi $v0, $zero, 1	#print total value
	add $a0, $zero, $s4
	syscall
	
	addi $v0, $zero, 10	#end program
	
	
