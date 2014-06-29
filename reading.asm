
	.data
fout: .asciiz "pilas2.txt" 
arreglo: .word  1 : 401
buffer: .resb 33
	.text
	
	li $s3, 2
	# open file
	li $v0, 13 #instruccion abrir archivo
	la $a0, fout #parametro nombre
	li $a1, 0
	li $a2, 0
	syscall #llamo a la instrucción
	move $s6, $v0 #guardo el registro de información del archivo en s6
set:
	li $s0, 0 #indice del arreglo
	addi $sp, $sp, -16 #bajo en la pila
	addi $t2, $zero, 0 #cargo para comparar el Null
	addi $t5, $zero, 32 #cargo para comparar el espacio
	addi $t3, $zero, 44 #cargo para comparar la coma
	addi $t9, $zero, 47 #cargo para comparar el slash
	move $t0, $zero #contador de iteraciones lectura de numeros
	move $t8, $zero
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
	move $s2, $t0
	#BubbleSort
	subi $t0, $t0, 1
loop5:	move $t4, $t0
	li $s0, 0 #inicializo el indice del arreglo
	addi $s0, $s0, 4
loop4:	lw $t1, arreglo($s0)
	addi $s0, $s0, 4
	lw $t2, arreglo($s0)
	slt $s1, $t1, $t2
	bne $s1, $zero, ordered
	sw $t1, arreglo($s0)
	addi $s0, $s0, -4
	sw $t2, arreglo($s0)
	addi $s0, $s0, 4
ordered:
	#lw $t8, arreglo($s0)
	#add $a0, $zero, $t8 #preparo para imprimir
	#li $v0, 1 #intruccion print 
	#syscall #ejecuto
	subi $t4, $t4, 1
	bne $t4, $zero, loop4
	subi $t0, $t0, 1
	bne $t0, $zero, loop5
	
	li $s0, 0 #inicializo el indice del arreglo
imp:	
	addi $s0, $s0, 4
	lw $t8, arreglo($s0)
	add $a0, $zero, $t8 #preparo para imprimir
	li $v0, 1 #intruccion print 
	syscall #ejecuto
	subi $s2, $s2, 1
	bne $s2, $zero, imp

	subi $s3, $s3, 1
	bne $s3, $zero, set
	#close file
	li $v0, 16
	move $a0, $s6
	syscall
