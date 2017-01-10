.data
msg: .asciiz "Please enter your integer: "
msg2: .asciiz "Here is the output: "

.text
	addi $v0, $zero, 4	#sycall 4: print string
	la $a0, msg		#store string in $a0
	syscall			#print string
	
	addi $v0, $zero, 5	#sycall 5: read integer
	syscall			#read integer	
	add $t0, $zero, $v0	#store integer in $t0
	
	srl $t1, $t0, 15	#shift right 15
	andi $t1, $t1, 7	#and integer in $t1 with 7
	
	addi $v0, $zero, 4	
	la $a0, msg2
	syscall
	
	addi $v0, $zero, 1	#syscall 1: print integer
	add $a0, $zero, $t1	#set integer to be printed
	syscall			#print integer
	
	addi $v0, $zero, 10	#sycall 10: exit program
	syscall			#exit program
	
	
