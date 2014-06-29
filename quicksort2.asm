
	.data
fout: .asciiz "pilas2.txt" 
insert_out: .asciiz "quicksorted_aleatorio.txt"
arreglo: .word  1 : 10
buffer: .space 40
	.text
	.globl main
	
	# open file
	li $v0, 13 #instruccion abrir archivo
	la $a0, fout #parametro nombre
	li $a1, 0
	li $a2, 0
	syscall #llamo a la instrucción
	move $s6, $v0 #guardo el registro de información del archivo en s6
	li $s0, 0 #indice del arreglo
	
	addi $sp, $sp, -16 #bajo en la pila
	addi $t2, $zero, 0 #cargo para comparar el Null
	addi $t5, $zero, 32 #cargo para comparar el espacio
	addi $t3, $zero, 44 #cargo para comparar la coma
	addi $t9, $zero, 47 #cargo para comparar el slash
	move $t0, $zero #contador de iteraciones lectura de numeros
loop3:
	add $t7, $zero, $zero #contador de digitos del numero
	#read file
loop:	li $v0, 14
	move $a0, $s6
	move $a1, $sp
	li $a2, 1
	syscall
	
	lw $t1, ($sp) #cargo el primer valor leido
	beq $t1, $t2, salEsp #reviso si es espacio
	beq $t1, $t5, salEsp #reviso si es espacio
	beq $t1, $t3, salComa #reviso si es coma
	beq $t1, $t9, salSls #reviso si es slash
	addi $t1, $t1, -48 #si es numero, le resto 48 para obtener el valor como entero
	sw $t1, ($sp) #guardo el nuevo valor en la pila
	addi $sp, $sp, 4 #subo en la pila a la siguiente posicion
	addi $t7, $t7, 1 #aumento el contador
salEsp:	
	beq $zero, $zero, loop #regreso al loop de leer un numero
	
salComa:
	addi $t4, $zero, 1 #inicializo el primer valor a multiplicar
	addi $t6, $zero, 10 #inicializo el factor a aumentar
	addi $sp, $sp, -4 #bajo la posicion extra que subi en el loop
	addi $t8, $zero, 0 #reseteo t8 que es el valor del numero a obtener
	
loop2:	lw $t1, ($sp) #cargo el primer valor de la pila
	mul $t1, $t1, $t4  #lo multiplico por uno
	add $t8, $t8, $t1 #lo acumulo
	addi $sp, $sp, -4 #me desplazo hacia abajo en la pila
	mul $t4, $t4, $t6 #aumento el factor que era 1 en 10
	addi $t7, $t7, -1 #revierto el contador 
	bne $t7, $zero, loop2 #verifico si es cero el contador
	
	addi $s0, $s0, 4 #avanzo el indice del arreglo en 4 bytes
	sw $t8, arreglo($s0) #accedo a la posicion del arreglo segun el valor de $s0, como en c arreglo[s0]
	addi $t0, $t0, 1 #aumento el contador de numeros
	lw $t8, arreglo($s0) #IMPRIMO CADA ELEMENTO DEL ARREGLO PARA SABER QUE ESTAN BIEN GUARDADOS
	add $a0, $zero, $t8 #preparo para imprimir
	li $v0, 1 #intruccion print 
	syscall #ejecuto

	beq $zero, $zero, loop3 #regreso al loop de sacar numeros
salSls:
	#close file
	li $v0, 16
	move $a0, $s6
	syscall
	
	
	
#----------------------------------------------------------------------
#    QUICKSORT
#----------------------------------------------------------------------

main:
	li $t0, 10		# $t0 contiene el size del arreglo
	la $a0, arreglo		# $a0 direccion del arreglo
	li $a1, 0		# $a1 contiene el indice del primer elemento
	addi $a2,$t0,-1 	# $a2 contiene el indice del ultimo elemento
	jal	quickSort	
	
	li	$v0, 10		# instruccion exit
	syscall
	
endMain:


	.text
	.globl	quickSort

# $a0 direccion del arreglo
# $a1 left
# $a2 right
# $s0 direccion
# $s1 left
# $s2 right
# $s3 pivot


quickSort:

	addi	$sp, $sp, -20		# inicializo un stack de 5 espacios
	sw	$s0, 4($sp)		# $s0
	sw	$s1, 8($sp)		# $s1
	sw	$s2, 12($sp)		# $s2
	sw	$s3, 16($sp)		# $s3
	sw	$ra, 20($sp)		# return address

	move	$s0, $a0		# copiar $a0 en $s0 (direccion)
	move 	$s1, $a1		# copiar $a1 en $s1 (left)
	move 	$s2, $a2		# copiar $a2 en $s2 (right)

if:
	blt	$s1, $s2, then		# if left < right
	j	endIf
then:

	move 	$a0, $s0
	move 	$a1, $s1
	move 	$a2, $s2
	jal	partition
	move 	$s3, $v0		# guardar el pivot

	move 	$a0, $s0
	move 	$a1, $s1
	addi 	$a2, $s3, -1
	jal	quickSort

	move 	$a0, $s0
	addi	$a1, $s3, 1
	move	$a2, $s2
	jal	quickSort

endIf:

	lw	$s0, 4($sp)		# reponer la pila 
	lw	$s1, 8($sp)		
	lw	$s2, 12($sp)		
	lw	$s3, 16($sp)		
	lw	$ra, 20($sp)		
	addi	$sp, $sp, 20		# reponer el stack pointer

	jr	$ra			# return address
endQuickSort:


	.text
	.globl partition

# $a0 direccion del arreglo
# $a1 left inicial
# $a2 right inicial
# $s0 direccion del arreglo
# $s1 el primer elemento del arreglo 
# $s2  left
# $s3  right
# $s4  pivot

# $t0 temporal
# $t1 temporal
# $t2 temporal
# $t4 offset de  4

partition:

addi	$sp, $sp, -24		# inicializo pila de 6 registros
sw	$s0, 4($sp)		
sw	$s1, 8($sp)		
sw	$s2, 12($sp)		
sw	$s3, 16($sp)		
sw	$s4, 20($sp)		
sw	$ra, 24($sp)		#

move	$s0, $a0		# copiar $a0 en $s0 (direccion)
move 	$s1, $a1		# copiar $a1 en $s1 (inicio)

# inicializar left, right, and pivot
move 	$s2, $s1
move 	$s3, $a2

li	$t4, 4
mul	$t0, $s1, $t4
add	$t0, $t0, $s0
lw	$s4, 0($t0)

while:
	blt	$s2, $s3, whileBody
	j	endWhile
whileBody:

	while_2:
		li	$t4, 4
		mul	$t0, $s3, $t4
		add	$t0, $t0, $s0
		lw	$t1, 0($t0)
		bgt	$t1, $s4, whileBody_2
		j	endWhile_2
	whileBody_2:
		addi	$s3, $s3, -1
		
		j	while_2
	endWhile_2:


	while_3:
		blt	$s2, $s3, andTest
		j	endWhile_3
	andTest:
		li	$t4, 4
		mul	$t1, $s2, $t4
		add	$t1, $t1, $s0
		lw	$t2, 0($t1)
		ble	$t2, $s4, whileBody_3
		j	endWhile_3
	whileBody_3:
		addi	$s2, $s2, 1
		
		j	while_3
	endWhile_3:

	if_2:
		blt	$s2, $s3, then_2
		j	endIf_2
	then_2:

		move	$a0, $t1
		move 	$a1, $t0
		jal	swap
	endIf_2:

	j	while
endWhile:

li	$t4, 4
mul	$t0, $s3, $t4
add	$t0, $t0, $s0
lw	$t1, 0($t0)

mul	$t2, $s1, $t4
add	$t2, $t2, $s0
sw	$t1, 0($t2)

sw	$s4, 0($t0)

move 	$v0, $s3		# return right
						#hago restore de toda la pila
lw	$s0, 4($sp)		
lw	$s1, 8($sp)		
lw	$s2, 12($sp)		
lw	$s3, 16($sp)		
lw	$s4, 20($sp)		
lw	$ra, 24($sp)		
addi	$sp, $sp, 24		# restore stack pointer

jr	$ra

endPartition:



	.text	
	.globl swap
swap:

# $a0  direccion operand1
# $a1  direccion operand2
# $t0  temp
# $t1  valor operand2



lw	$t0, 0($a0)
lw	$t1, 0($a1)

sw	$t1, 0($a0)
sw	$t0, 0($a1)

jr	$ra

endSwap:	



	