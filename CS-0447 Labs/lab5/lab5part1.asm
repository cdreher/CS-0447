.data
types: .asciiz "bit", "nybble", "byte", "half", "word"
bits: .asciiz "one", "four", "eight", "sixteen", "thirty-two"
str: .space 64
greeting: .asciiz "Please enter a datatype: "
notFoundMsg: .asciiz "Not found!"
bitsMsg: .asciiz "Number of bits: "
.text
MAIN:
	addi $v0, $zero, 4		#prompt user to enter datatype
	la $a0, greeting
	syscall
	
	jal _readString			#get correct strLength of input
	
	add $s0, $zero, $s1		#place length into a saved register $s0
	add $s2, $zero, 0		#USE THIS AS THE "TYPES" LIST INDEX
	add $s3, $zero, 0		#USE THIS AS THE "BITS" LIST INDEX

	
	la $a0, types
	jal _checkType

Loop1:
_checkType:
	beq $v1, 1, replace		#replace $a0 with the "bits" list if match found
	beq $s2, 5, notFound		#if match is not found, end program
	
	addi $s1, $zero, 0		#reset register $s1
	
	la $a1, ($a0)			#place copy of current "types" list into another register, for later comparison
	jal _strLength			#call _strLength to get length of "types" list string
	
	jal _return
	
	j	Loop1			#loop back through if match is not found
	
_return:
	beq $s0, $s1, check		#if string lengths match, check if the words are the same
	
	returnLoop:
		addi $v1, $zero, 0		#return 0
		add $s2, $s2, 1			#increment type index by 1
		addi $a0, $a0, 1		#increment "types" list by 1

		jr $ra

check:
	cLoop:
		lbu $t2, 0($a1)		#load next character of "types" copy to $t2
		lbu $t3, 0($a2)		#load next character of input copy to $t3
		
		beq $t2, 0, set1	#ONLY FOR IF WORDS MATCH ALL THE WAY THROUGH
		bne $t2, $t3, cExit	#if characters do not match, exit b/c words are not the same
		
		addi $a1, $a1, 1	#increment "types" copy string pointer
		addi $a2, $a2, 1	#increment input copy string pointer
		j	cLoop	
	cExit:	j	returnLoop

set1:
	addi $v1, $zero, 1		#set value of 1 to be returned
	jr $ra	
	
replace:	
	la $a0, bits
	j	Loop2			#jump to _lookUp function loop
	
Loop2:
_lookUp:
	beq $s2, $s3, print
	
	jal _strLength
	
	addi $s3, $s3, 1		#increment bit index by 1
	addi $a0, $a0, 1		#increment "bits" list by 1
	
	j	Loop2
	
print:
	la $a3, ($a0)			#place number of bits into $a3
	
	addi $v0, $zero, 4		#print message
	la $a0, bitsMsg
	syscall
	
	addi $v0, $zero, 4		#output number of bits
	la $a0, ($a3)
	syscall

	addi $v0, $zero, 10		#end program
	syscall

_readString:
	addi $v0, $zero, 8		#sycall 8: read string
	la $a0, str			#store string in $a0
	la $a2, str			#make a copy into another register for later word comparison
	addi $a1, $zero, 64		#max bytes = 64
	syscall
	
	la $t7, ($ra)

	jal _strLength			#call function _strLength
	
	addi $s1, $s1, -1		#take counter agrument from _strLength
					#then chop off \n character from counter
	add $t0, $s1, $a0
	sb $zero, 0($t0)
	la $ra, ($t7)
	jr $ra
_strLength:
	addi $t0, $zero, 0		#initialize counter to zero
	Loop:
		lbu $t1, 0($a0)		#load next character to $t1
		beq $t1, 0, exit	#once null character is hit, exit function
		addi $a0, $a0, 1	#increment string pointer
		addi $t0, $t0, 1	#increment counter by 1
		j	Loop	
	exit:	
		add $s1, $zero, $t0	#put counter into return register $s1
		jr $ra

notFound:
	addi $v0, $zero, 4		
	la $a0, notFoundMsg
	syscall
	
	addi $v0, $zero, 10
	syscall
