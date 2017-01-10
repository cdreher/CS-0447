.text

# $t9 = 179 + (–293) + 561

addi $t9, $zero, 0
addi $t9, $t9, 179

addi $t9, $t9, -293
addi $t9, $t9, 561

j top_of_loop

top_of_loop: addi $t1, $zero, 0

addi $v0, $zero, 32
addi $a0, $zero, 500
syscall
