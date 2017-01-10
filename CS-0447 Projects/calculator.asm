//Collin Dreher - Project 1 (Calculator)
.text

addi $s0, $zero, 0			#use this register for the result
addi $t0, $zero, 0			#use as temp
addi $t1, $zero, 0			#temp
add $t2, $zero, 0			#use this as the counter for multiplication
add $t3, $zero, 0			#use this as the counter for division

state0:
	addi $t5, $zero, 0		#set operand 1 to 0
	addi $t6, $zero, 0		#set operand 2 to 0
	addi $t7, $zero, 0		#set operator to nothing
	addi $t2, $zero, 0		#reset multi counter
	addi $s0, $zero, 0		#reset result
	addi $t4, $zero, 0		#reset slti register
	addi $t3, $zero, 0		#reset division counter
	add $t8, $zero, $t5		#display operand 1
	addi $t9,  $zero, 0
	j	state1			#jump to state 1

state1:
	loop:
		beq $t9, $zero, loop	#run loop until something is pushed
		andi $t9, $t9, 31	#get MSB to see what button is pushed
		beq $t9, 10, done
		beq $t9, 11, done
		beq $t9, 12, done
		beq $t9, 13, done
		beq $t9, 14, s1Result
		beq $t9, 15, clear	
		
		add $t0, $zero, $t5
		add $t1, $zero, $t5
		sll $t0, $t0, 3		#multiply by 10
		add $t5, $t5, $t0
		add $t5, $t5, $t1
			
		add $t5, $t5, $t9	#(operand1 * 10) + input
		add $t8, $zero, $t5	#display operand1
		addi $t9, $zero, 0	#reset input
		j	loop

state2:
	s2Loop:
		beq $t9, $zero, s2Loop	#run loop until something is pushed
		andi $t9, $t9, 31	#get MSB to see what button is pushed
		beq $t9, 10, done
		beq $t9, 11, done
		beq $t9, 12, done
		beq $t9, 13, done
		beq $t9, 14, result
		beq $t9, 15, clear	
		
		add $t0, $zero, $t6
		add $t1, $zero, $t6
		sll $t0, $t0, 3		#multiply by 10
		add $t6, $t6, $t0
		add $t6, $t6, $t1
		
		add $t6, $t6, $t9	#(operand2 * 10) + input
		add $t8, $zero, $t6	#display operand2
		addi $t9, $zero, 0	#reset input
		j	state3
	
state3:
	s3Loop:
		beq $t9, $zero, s3Loop	#run loop until something is pushed
		andi $t9, $t9, 31	#get MSB to see what button is pushed
		beq $t9, 10, result
		beq $t9, 11, result
		beq $t9, 12, result
		beq $t9, 13, result
		beq $t9, 14, result
		beq $t9, 15, clear	
		
		add $t0, $zero, $t6
		add $t1, $zero, $t6
		sll $t0, $t0, 3		#multiply by 10
		add $t6, $t6, $t0
		add $t6, $t6, $t1
		
		add $t6, $t6, $t9	#(operand2 * 10) + input
		add $t8, $zero, $t6	#display operand2
		addi $t9, $zero, 0	#reset input
		j	state3
state4:
	s4Loop:
		beq $t9, $zero, s4Loop	#run loop until something is pushed
		andi $t9, $t9, 31	#get MSB to see what button is pushed
		beq $t9, 10, addToResult
		beq $t9, 11, addToResult
		beq $t9, 12, addToResult
		beq $t9, 13, addToResult
		beq $t9, 14, result
		beq $t9, 15, clear	
		
		add $t5, $zero, $t9	#operand1 = input
		add $t8, $zero, $t5	#display operand1
		addi $t9, $zero, 0	#reset input
		addi $t7, $zero, 0	#reset operator
		j	state1

done:
	add $t7, $zero, $t9		#operator = input
	add $t8, $zero, $t5		#display operand1
	addi $t9, $zero, 0		#reset input
	j	state2

s1Result:
		add $s0, $zero, $t5	#result = operand1
		add $t8, $zero, $s0	#display result
		j	state4

result:
	#bne $t9, 14, addToResult	#if user wants to ADD TO RESULT
	beq $t7, 10, addResult
	beq $t7, 11, subResult
	beq $t7, 12, multiResult
	beq $t7, 13, divResult
	
	addResult:
		add $s0, $t5, $t6	#result = operand1 + operand2
		add $t8, $zero, $s0	#display result
		add $t6, $zero, 0	#operand2 = 0
		bne $t9, 14, jState2
		addi $t9, $zero, 0	#reset input
		j	state4
	subResult:
		sub $s0, $t5, $t6	#result = operand1 - operand2
		add $t8, $zero, $s0	#display result
		add $t6, $zero, 0	#operand2 = 0
		bne $t9, 14, jState2
		addi $t9, $zero, 0	#reset input
		j	state4
	multiResult:
		beq $t2, $t6, display
		add $s0, $s0, $t5	#add operand1
		add $t2, $t2, 1		#increment counter by 1
		j	multiResult
		display:
			add $t8, $zero, $s0	#display result
			add $t6, $zero, 0	#operand2 = 0
			bne $t9, 14, jState2
			addi $t9, $zero, 0	#reset input
			j	state4
	divResult:
		add $s0, $zero, $t5
		divLoop:
			slt $t4, $s0, $t6	#once $s0 goes below operand2, stop counting & return
			beq $t4, 1, displayDivCounter
			sub $s0, $s0, $t6	#subtract operand2
			addi $t3, $t3, 1	#increment div counter by 1
			j	divLoop
		displayDivCounter:
			add $t8, $zero, $t3	#display result (div counter)
			add $t6, $zero, 0	#operand2 = 0
			bne $t9, 14, jState2Div
			addi $t9, $zero, 0	#reset input
			j	state4
		
	jState2: 
		add $t5, $zero, $s0	#operand1 = result
		add $t7, $zero, $t9	#operator = input
		add $s0, $zero, 0	#reset result
		addi $t9, $zero, 0	#reset input	
		j	state2
	jState2Div:
		add $t5, $zero, $t3	#operand1 = result
		add $t7, $zero, $t9	#operator = input
		add $t3, $zero, 0	#reset result
		addi $t9, $zero, 0	#reset input	
		j	state2
	
	addToResult:
		beq $t9, 13, division	#if user wants to continue dividing, then jump down...
		
		add $t5, $zero, $s0	#operand1 = result
		#add $t7, $zero, 0	#reset operator, BECAUSE "done" sets it again
		add $s0, $zero, 0	#reset result
		add $t2, $zero, 0	#reset multi counter
		j	state2
		
		division:
			add $t5, $zero, $t3	#operand1 = result
			#add $t7, $zero, 0	#reset operator, BECAUSE "done" sets it again
			add $s0, $zero, 0	#reset result
			addi $t3, $zero, 0	#reset division counter
			addi $t4, $zero, 0	#reset slti register
			j	state2
			
	
clear:
	j	state0
	
