//Collin Dreher - Project 2 (Simon)
.data
pattern: .space 200

.text
main:
	addi $t9, $zero, 0		#set input to 0
	addi $s1, $zero, 1		#start length of sequence at 1
	addi $s0, $zero, 0		#array index
	addi $s2, $zero, 0
	addi $t1, $zero, 0		#counter for input
	
	add $a0, $zero, $s0			#pass index in as arg0
	add $a1, $zero, $s1			#pass round length in as arg1
	add $a2, $zero, $s2	
	add $a3, $zero, $t1			#pass input counter in as arg3		
	jal _userPlay
	
	add $a0, $zero, $s0			#pass index in as arg0
	add $a1, $zero, $s1			#pass round length in as arg1
	add $a2, $zero, $s2	
	jal _playSequence
	
	beq $v0, 1, wrongAnswer
	wrongAnswer:	jal _wrongResponse
	
_userPlay:
	add $s0, $zero, $a0			#place index arg into $s0
	add $s1, $zero, $a1			#place round length arg into $s1
	add $s2, $zero, $a2	
	add $t1, $zero, $a3			#place counter arg into $t1
	uLoop:
		beq $t9, $zero, uLoop		#run loop until something is pushed
		andi $t9, $t9, 31		#get MSB to see what button is pushed
		beq $t9, 1, blue
		beq $t9, 2, yellow
		beq $t9, 4, green
		beq $t9, 8, red
		beq $t9, 16, start
	start:
		addi $t8, $zero, 16		#start game
		addi $t9, $zero, 0		#reset input
		jr $ra
	blue:
		addi $t8, $zero, 1			#light blue button and play its tone
		lb $s2, pattern($s0)
		bne $t9, $s2, wrong
	
		addi $t1, $t1, 1			#increment input counter
		addi $s0, $s0, 4			#increment index
		beq $t1, $s1, jump
	
		addi $t9, $zero, 0
		j	uLoop
	yellow:
		addi $t8, $zero, 2			#light yellow button and play its tone
		lb $s2, pattern($s0)	
		bne $t9, $s2, wrong
	
		addi $t1, $t1, 1			#increment input counter
		addi $s0, $s0, 4			#increment index
		beq $t1, $s1, jump
	
		addi $t9, $zero, 0
		j	uLoop
	green:
		addi $t8, $zero, 4			#light green button and play its tone
		lb $s2, pattern($s0)	
		addi $s2, $s2, 1			#add 1 so $s2 is appropriate button value
		bne $t9, $s2, wrong	
	
		addi $t1, $t1, 1			#increment input counter
		addi $s0, $s0, 4			#increment index
		beq $t1, $s1, jump
	
		addi $t9, $zero, 0
		j	uLoop
	red:
		addi $t8, $zero, 8			#light red button and play its tone
		lb $s2, pattern($s0)	
		addi $s2, $s2, 4			#add 4 so $s2 is appropriate button value
		bne $t9, $s2, wrong
	
		addi $t1, $t1, 1			#increment input counter
		addi $s0, $s0, 4			#increment index
		beq $t1, $s1, jump
	
		addi $t9, $zero, 0
		j	uLoop
	jump:
		addi $s1, $s1, 1			#increment sequence length
		addi $t1, $zero, 0			#reset input counter temp
		addi $t9, $zero, 0			#reset input
		
		add $a0, $zero, $s0			#pass index in as arg0
		add $a1, $zero, $s1			#pass round length in as arg1
		add $a2, $zero, $s2			
		jal _playSequence
	wrong:
		addi $v0, $zero, 1
		jr $ra
	
_playSequence:
	add $s0, $zero, $a0			#place index arg into $s0
	add $s1, $zero, $a1			#place round length arg into $s1
	add $s2, $zero, $a2			
	createArray:
		beq $s1, $t0, finished		#if sequence length is reached, play sequence
		li $v0, 42			#random int syscall
		addi $a1, $zero, 4		#random number between 0-3
		syscall
		
		addi $a0, $a0, 1		#add 1 to random int, 
		sw $a0, pattern($s0)		#load randomly generated int in array
		lb $s2, pattern($s0)
		addi $s0, $s0, 4
		addi $t0, $t0, 1		#increment temp length 
		j	createArray
	
	finished:
		addi $s0, $zero, 0		#reset index
		j	playLoop
	
	playLoop:
		beq $t2, $s1, callUser
		lb $s2, pattern($s0)
		beq $s2, 1, lightBlue			#1=blue, 2=yellow, 3=green, 4=red
		beq $s2, 2, lightYellow
		beq $s2, 3, lightGreen
		beq $s2, 4, lightRed
	lightBlue:
		addi $t8, $zero, 1			#light blue button and play its tone
		addi $s0, $s0, 4			#increment index
		addi $t2, $t2, 1			#increment temp for buttons displayed
		j	playLoop
	lightYellow:
		addi $t8, $zero, 2			#light yellow button and play its tone
		addi $s0, $s0, 4			#increment index
		addi $t2, $t2, 1			#increment temp for buttons displayed
		j	playLoop
	lightGreen:
		addi $t8 , $zero, 4
		addi $s0, $s0, 4			#increment index
		addi $t2, $t2, 1			#increment temp for buttons displayed
		j	playLoop
	lightRed:
		addi $t8, $zero, 8
		addi $s0, $s0, 4			#increment index
		addi $t2, $t2, 1			#increment temp for buttons displayed
		j	playLoop

	callUser:	
		addi $s2, $zero, 0		#reset temp
		addi $s0, $zero, 0		#reset index 
		addi $t2, $zero, 0		#reset _playSequence button temp
	
		add $a0, $zero, $s0			#pass index in as arg0
		add $a1, $zero, $s1			#pass round length in as arg1
		add $a2, $zero, $s2	
		add $a3, $zero, $t1			#pass input counter in as arg3	
		jal _userPlay

_wrongResponse:
	addi $t8, $zero, 15		#play game over tone, light all colors, enable Start Game button
	addi $t0, $zero, 0		#reset all necessary registers
	addi $s2, $zero, 0			
	addi $s1, $zero, 0	
	addi $t9, $zero, 0
	addi $t1, $zero, 0
	addi $t2, $zero, 0
	addi $s0, $zero, 0
	j	main



