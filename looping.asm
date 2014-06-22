
	.data
fout: .asciiz "pilas2.txt" 
buffer: .resb 33

	.text
	# open file
	li $v0, 13 #instruccion abrir archivo
	la $a0, fout #parametro nombre
	li $a1, 1
	li $a2, 0
	syscall #llamo a la instrucción
	move $s6, $v0 #guardo el registro de información del archivo en s6
	addi $t3, $zero, 15 #contador loop externo
	la $s3, buffer #cargo buffer
	
loop2:	li $a1, 200 #establesco 200 como random maximo
	li $v0, 42 #instrucción para random
	syscall #ejecuto
	li $v0, 1 #intruccion print de $a0 donde esta el random
	syscall #ejecuto
	
	addi $sp, $sp, -16 #desplazo 3*4 bytes la pila
	addi $t4, $zero, 44 #la coma
	sw $t4, ($sp)	#guardo t2 en la pila
	addi $sp, $sp, 4
	
loop1:	addi $t0, $zero, 10
	div  $a0, $t0       # $a0/10
	mflo $a1           # $a1 = quotient
	mfhi $t0           # $t0 = remainder
	addi $a0, $t0, 0x30    # convert to ASCII
	add $t2, $a0, $zero	#cargo en t2 el residuo en ascii
	sw $t2, ($sp)	#guardo t2 en la pila
	
	addi $sp, $sp, 4
	add $a0, $a1, $zero
	bne $a0, $zero, loop1
	#Grabar primer numero
	addi $sp, $sp, -4 #me desplazo 4 bytes hacia abajo en la pila para el primer digito
	#write file
	li $v0, 15 #instruccion write
	move $a0, $s6 #cargo la descripcion del archivo que tenia guardada en s6
	move $a1, $sp #pongo  el valor del digito en ascii como parametro
	li $a2, 1 
	syscall #exporto el num al archivo
	#Grabar segundo numero
	addi $sp, $sp, -4
	#write file
	li $v0, 15
	move $a0, $s6
	move $a1, $sp
	li $a2, 1
	syscall
	#Grabar tercer numero
	addi $sp, $sp, -4
	#write file
	li $v0, 15
	move $a0, $s6
	move $a1, $sp
	li $a2, 1
	syscall
	#Grabar coma
	addi $sp, $sp, -4
	#write file
	li $v0, 15
	move $a0, $s6
	move $a1, $sp
	li $a2, 1
	syscall
	
	addi $t3, $t3, -1 #resto para el contador
	bne $t3, $zero, loop2 #regreso a generar otro numero
	
	addi $t4, $zero, 10 #enter
	sb $t4, buffer #agrego el enter al buffer
	#write file
	li $v0, 15
	move $a0, $s6
	move $a1, $s3
	li $a2, 1
	syscall
	
	#close file
	li $v0, 16
	move $a0, $s6
	syscall
