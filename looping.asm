
	.data
fout: .asciiz "pilas2.txt" 
buffer: .resb 10


	.text
	# open file
	li $v0, 13 
	la $a0, fout
	li $a1, 1
	li $a2, 0
	syscall
	move $s6, $v0
	
	li $a1, 200
	li $v0, 42
	syscall
	li $v0, 1
	syscall

	la $t3, buffer

loop1:	addi $t0, $zero, 10
	div  $a0, $t0       # $a0/10
	mflo $a1           # $a1 = quotient
	mfhi $t0           # $t0 = remainder
	addi $a0, $t0, 0x30    # convert to ASCII
	#sll $t0, $t0, 8
	#or $a3, $a1, $t0
	add $t2, $a0, $zero
	sb $t2, buffer
	
	add $t4, $a1, $zero
	
	#write file
	li $v0, 15
	move $a0, $s6
	move $a1, $t3
	li $a2, 3
	syscall
	
	add $a0, $t4, $zero
	bne $a0, $zero, loop1
	
	#close file
	li $v0, 16
	move $a0, $s6
	syscall
