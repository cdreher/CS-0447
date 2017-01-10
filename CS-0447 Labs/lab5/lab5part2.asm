.data
msg: .asciiz "Enter a nonnegative integer: "
msg2: .asciiz "Fib("
msg3: .asciiz ") = "
error: .asciiz "Invalid integer, try again!\n"

.text
main:
	addi $v0, $zero, 4
	la $a0, msg
	syscall
	
	addi $v0, $zero, 5		#read user input integer
	syscall
	add $a1, $v0, $zero		#place user input in $a1
	add $a2, $v0, $zero		#make copy as well for output purposes

	srl $v1, $v0, 31		#shift input to see if negative
	and $v1, $v1, 1
	bne $v1, 1, notNegative
	
	addi $v0, $zero, 4		#if negative, prompt user to re-enter integer
	la $a0, error
	syscall
	
	j	main
	
notNegative:	
	jal _fib			#call Fibonacci function
	
	add $a1, $v0, $zero
	
	addi $v0, $zero, 4		
	la $a0, msg2
	syscall
		
	addi $v0, $zero, 1		#print input integer
	add $a0, $zero, $a2
	syscall
	
	addi $v0, $zero, 4		
	la $a0, msg3
	syscall
	
	addi $v0, $zero, 1		#print result
	add $a0, $zero, $a1
	syscall
	
	addi $v0, $zero, 10		#end program
	syscall		
	
_fib:
	addi $sp, $sp, -12
	sw $ra, 0($sp)			#save registers to stack
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	add $s0, $a1, $zero
	
	addi $t1, $zero, 1

	beq $s0, $zero, ret0
	beq $s0, $t1, ret1
	
	add $a1, $s0, -1		#fib(n-1)
	jal _fib			#recursively call fib function
	add $s1, $zero, $v0
	
	addi $a1, $s0, -2		#fib(n-2)
	jal _fib			#recursively call fib function
	
	add $v0, $v0, $s1
	
exit:
	lw $ra, ($sp)
	lw $s0, 4($sp)			#save registers to stack
	lw $s1, 8($sp)
	addi $sp, $sp, 12		#add back to stack
	jr $ra
	
ret0:
	li $v0, 0			#return 0
	j	exit
ret1:	
	li $v0, 1			#return 1
	j	exit


	
	
