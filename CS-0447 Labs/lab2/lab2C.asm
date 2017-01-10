.text
addi $v0, $zero, 40	#syscall 40
addi $a0, $zero, 0	#set RNG seed to 0
addi $a1, $zero, 3	#set upper bound
syscall

addi $s3, $zero, 82	#set R
addi $s4, $zero, 80	#set P
addi $s5, $zero, 83	#set S
addi $s6, $zero, 81	#set Q

Loop:
	.data
	promptStart: .asciiz "Make a move (R, P, S, Q): "
	.text
		addi $v0, $zero, 4	#print first statement
		la $a0, promptStart
		syscall
	
		addi $v0, $zero, 12	#read character input
		syscall
		add $s0, $zero, $v0
	
		addi $v0, $zero, 42	#syscall 42
		add $a0, $zero, 0	#set RNG seed to 0
		add $a1, $zero, 3	#set upper bound
		syscall
		add $s1, $zero, $a0	#copy random number to $s1

		beq $s0, $s3, rock	#if user picks rock
		beq $s0, $s4, paper	#if user picks paper
		beq $s0, $s5, scissors	#if user picks scissors
		beq $s0, $s6, quit	#if user quits

paper:
.text
	beq $s1, 0, win
	beq $s1, 1, tie
	beq $s1, 2, lose
scissors:
.text
	beq $s1, 0, lose
	beq $s1, 1, win
	beq $s1, 2, tie
rock:
.text
	beq $s1, 0, tie
	beq $s1, 1, lose
	beq $s1, 2, win
	
win:
	.data
	promptWin: .asciiz "\nYou won congrats!\n"
	.text
		addi $v0, $zero, 4	
		la $a0, promptWin
		syscall
		j	Loop
	
lose:
	.data
	promptLose: .asciiz "\nYou lost, better luck next time!\n"
	.text
		addi $v0, $zero, 4	
		la $a0, promptLose
		syscall
		j	Loop
tie:
	.data
	promptTie: .asciiz "\nTie.\n"
	.text
		addi $v0, $zero, 4	
		la $a0, promptTie
		syscall
		j	Loop
	
quit:
	addi $v0, $zero, 10	#ends program
	syscall
