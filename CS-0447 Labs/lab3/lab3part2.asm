.data
msgXY: .asciiz "x*y calculator\n"
msg1: .asciiz "Please enter x: "
msg2: .asciiz "Please enter y: "
multiply: .asciiz "*"
equalSign: .asciiz " = "
error: .asciiz "Integer must be nonnegative.\n"

.text
	addi $v0, $zero, 4	#syscall 4: print string
	la $a0, msgXY		#store string in $a0
	syscall			#print string
	
LoopX:
	addi $v0, $zero, 4
	la $a0, msg1
	syscall
	
	addi $v0, $zero, 5	#syscall 5: read integer
	syscall			#read integer
	
	srl $v1, $v0, 31
	and $v1, $v1, 1	
	bne $v1, 1, NotNegativeX	#if integer entered is negative, go to the loop
	
	addi $v0, $zero, 4
	la $a0, error
	syscall
	j	LoopX

NotNegativeX: 
	add $t0, $zero, $v0	#store integer A in $t0
	add $t6, $zero, $t0	#make copy of A into $t6
	
LoopY:
	addi $v0, $zero, 4
	la $a0, msg2
	syscall
	
	addi $v0, $zero, 5	#syscall 5: read integer
	syscall			#read integer
	
	srl $v1, $v0, 31
	and $v1, $v1, 1
	bne $v1, 1, NotNegativeY	#if integer entered is negative, go to the loop
	
	addi $v0, $zero, 4
	la $a0, error
	syscall
	j	LoopY

NotNegativeY:
	add $t1, $zero, $v0	#store integer B in $t1
	add $t7, $zero, $t1	#make copy of B

	add $t2, $zero, $zero	#set shifting counter to zero, store in $t2
	
	add $t3, $zero, $zero	#set result to zero, store in $t3
	
	bne $t1, $zero, increment	#go to loop if B != 0
	
increment:
	beq $t1, $zero, leaveLoop	#leave loop if B == 0
	andi $a1, $t1, 1		#check first bit in B
	beq $a1, 1, ifOne		#if first bit == 1, then go to ifOne
	bne $a1, 1, notOne
	j increment
	
notOne:
	addi $t2, $t2, 1		#shifting counter++
	srl $t1, $t1, 1			#shift B to right one time
	j	increment

ifOne:
	sllv $t4, $t0, $t2	#shift A left by shifting counter, put it in register $t4
	add $t3, $t3, $t4	#Result = Result + (A << shiftin counter)
	
	addi $t2, $t2, 1		#shifting counter++
	srl $t1, $t1, 1			#shift B to right one time
	j	increment
	
leaveLoop:
	addi $v0, $zero, 1	#syscall 1: print integer
	add $a0, $zero, $t6	#set integer A to be printed
	syscall			#print integer
	
	addi $v0, $zero, 4
	la $a0, multiply
	syscall
	
	addi $v0, $zero, 1	#syscall 1: print integer
	add $a0, $zero, $t7	#set integer B to be printed
	syscall			#print integer
	
	addi $v0, $zero, 4
	la $a0, equalSign
	syscall
	
	addi $v0, $zero, 1
	add $a0, $zero, $t3
	syscall
