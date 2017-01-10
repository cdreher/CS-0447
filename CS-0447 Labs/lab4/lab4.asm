.data
stringMsg: .asciiz "Please enter a string: \n"
str: .space 64		#create space for input string
output: .space 64
strLengthMsg1: .asciiz "This string has a length of "
strLengthMsg2: .asciiz " characters.\n"
startMsg: .asciiz "Specify start index: "
endMsg: .asciiz "Specify end index: "
subStringMsg: .asciiz "Your substring is:\n"

.text
main:
	addi $v0, $zero, 4		#print greeting string message
	la $a0, stringMsg
	syscall
	
	jal _readString			#call function _readString
	
	addi $v0, $zero, 4
	la $a0, strLengthMsg1
	syscall
	
	addi $v0, $zero, 1		#print string length counter
	add $a0, $zero, $v1
	syscall
	
	addi $v0, $zero, 4
	la $a0, strLengthMsg2
	syscall
	
	addi $v0, $zero, 4
	la $a0 startMsg
	syscall
	
	addi $v0, $zero, 5		#read user input for start index, store in $a2
	syscall
	add $a2, $zero, $v0
	
	addi $v0, $zero, 4
	la $a0, endMsg
	syscall
	
	addi $v0, $zero, 5		#read user input for end index, store in $a3
	syscall
	add $a3, $zero, $v0
	
	la $a1, output			#output string register
	la $a0, str			#input string register
	jal _subString			#call function _subString
	
	addi $v0, $zero, 4
	la $a0, subStringMsg
	syscall
	
	addi $v0, $zero, 4		#print output substring
	la $a0, 0($a1)
	syscall
	
	addi $v0, $zero, 10		#end program
	syscall

_strLength:
	addi $t0, $zero, 0		#initialize counter to zero
	Loop:
		lbu $t1, 0($a0)		#load next character to $t1
		beq $t1, 0, exit	#once null character is hit, exit function
		addi $a0, $a0, 1	#increment string pointer
		addi $t0, $t0, 1	#increment counter by 1
		j	Loop	
	exit:	
		add $v1, $zero, $t0	#put counter into return register $v1
		jr $ra
	
_readString:
	addi $v0, $zero, 8		#sycall 8: read string
	la $a0, str			#store string in $a0
	addi $a1, $zero, 64		#max bytes = 64
	syscall
	
	la $t7, ($ra)

	jal _strLength			#call function _strLength
	
	addi $v1, $v1, -1		#take counter agrument from _strLength
					#then chop off \n character from counter
	add $t0, $v1, $a0
	sb $zero, 0($t0)
	la $ra, ($t7)
	jr $ra
	
_subString:
	add $t6, $zero, $a0		#use $t6 as input since $t0 is used in _strLength
	add $t8, $zero, $a1		#use $t8 as output since $t1 is also used in _strLength
	add $t2, $zero, $a2		#first index
	add $t3, $zero, $a3		#second index
	add $t4, $zero, 0		#temp register for bytes
	la $t7, ($ra)
	
	slt $t4, $t3, $t2		#check if second index is less than the first index
	beq $t4, 1, end
	
	slti $t4, $t2, 0		#check if first index is negative
	beq $t4, 1, end
	
	slti $t4, $t3, 0		#check if second index is negative
	beq $t4, 1, end
	
	jal	_strLength
	addi $v1, $v1, -1
	
	slt $t4, $v1, $t3
	bne $t4, 1, subLoop		#if second index is not too big, move to subLoop
	addi $t3, $v1, 0		#otherwise, reset it to the length of the string
	
	subLoop:
		beq $t2, $t3, end
		add $t4, $t6, $t2		#add inputStringAddress with start index
		lbu $t4, ($t4)
		sb $t4, ($t8)
		addi $t8, $t8, 1
		addi $t2, $t2, 1
		j	subLoop

	
	
	end:
		la $ra, ($t7)
		jr $ra
	
	
