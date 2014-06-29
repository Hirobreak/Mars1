
	.data
fout: .asciiz "aleatorios.txt" 
foutbub: .asciiz "bur_aleatorios.txt" 
arreglo: .word  1 : 401
buffer: .resb 33
	.text
		
	li $s3, 10
	# open file
	li $v0, 13 #instruccion abrir archivo
	la $a0, fout #parametro nombre
	li $a1, 0
	li $a2, 0
	syscall #llamo a la instrucción
	move $s6, $v0 #guardo el registro de información del archivo en s6
	# open file
	li $v0, 13 #instruccion abrir archivo
	la $a0, foutbub #parametro nombre
	li $a1, 1
	li $a2, 0
	syscall #llamo a la instrucción
	move $s5, $v0 #guardo el registro de información del archivo en s6
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
	#BubbleSort
	li $v0, 30 #preparo parametro funcion obtener tiempo
	syscall #llamo a la funcion obtener tiempo
	move $s7, $a0 #guardo el tiempo en s7
	
	move $s2, $t0 #valor de la cantidad de numeros, for externo s2
	subi $t0, $t0, 1 #el for interno tiene una iteracion menos
loop5:	move $t4, $t0 #
	li $s0, 0 #inicializo el indice del arreglo
	addi $s0, $s0, 4 #el arreglo comienza una posicion mas
loop4:	lw $t1, arreglo($s0) #accedo al numero de ese indice
	addi $s0, $s0, 4 #avanzo
	lw $t2, arreglo($s0) #accedo el otro numero
	slt $s1, $t1, $t2 #comparo t1 < t2
	bne $s1, $zero, ordered #si no es falso salto a ordered
	sw $t1, arreglo($s0) #SWAPING
	addi $s0, $s0, -4
	sw $t2, arreglo($s0)
	addi $s0, $s0, 4
ordered:
	subi $t4, $t4, 1 #redusco el valor de iteraciones del for interno en 1
	bne $t4, $zero, loop4 #salto de regreso si aun hay iteraciones restantes
	subi $t0, $t0, 1 #redusco el valor de iteraciones del for externo en 1
	bne $t0, $zero, loop5 #salto de regreso si aun hay iteraciones restantes
	
	li $s0, 0 #inicializo el indice del arreglo
imp:	
	addi $s0, $s0, 4 #avanzo una posicion en el arreglo
	lw $t8, arreglo($s0) #leo el numero
	add $a0, $zero, $t8 #preparo para imprimir
	li $v0, 1 #intruccion print 
	syscall #ejecuto
	subi $s2, $s2, 1 #contador de numeros que escribire
	#grabar el numero
	addi $sp, $sp, -16 #desplazo 3*4 bytes la pila
	addi $t4, $zero, 44 #la coma
	sw $t4, ($sp)	#guardo t2 en la pila
	addi $sp, $sp, 4 #avanzo en la pila
	
loopn1:	addi $t0, $zero, 10
	div  $a0, $t0       # $a0/10
	mflo $a1           # $a1 = quotient
	mfhi $t0           # $t0 = remainder
	addi $a0, $t0, 0x30    # convert to ASCII
	add $t2, $a0, $zero	#cargo en t2 el residuo en ascii
	sw $t2, ($sp)	#guardo t2 en la pila
	
	addi $sp, $sp, 4
	add $a0, $a1, $zero
	bne $a0, $zero, loopn1
	#Grabar primer numero
	addi $sp, $sp, -4 #me desplazo 4 bytes hacia abajo en la pila para el primer digito
	#write file
	li $v0, 15 #instruccion write
	move $a0, $s5 #cargo la descripcion del archivo que tenia guardada en s6
	move $a1, $sp #pongo  el valor del digito en ascii como parametro
	li $a2, 1 
	syscall #exporto el num al archivo
	#Grabar segundo numero
	addi $sp, $sp, -4
	#write file
	li $v0, 15
	move $a0, $s5
	move $a1, $sp
	li $a2, 1
	syscall
	#Grabar tercer numero
	addi $sp, $sp, -4
	#write file
	li $v0, 15
	move $a0, $s5
	move $a1, $sp
	li $a2, 1
	syscall
	#Grabar coma
	addi $sp, $sp, -4
	#write file
	li $v0, 15
	move $a0, $s5
	move $a1, $sp
	li $a2, 1
	syscall
	
	bne $s2, $zero, imp #si aun hay numeros que imprimir regreso a imp
	
	la $t9, buffer #cargo buffer
	addi $t4, $zero, 47 #backslash
	sb $t4, buffer #agrego el backslash al buffer
	#write file
	li $v0, 15
	move $a0, $s5
	move $a1, $t9
	li $a2, 1
	syscall
	subi $s3, $s3, 1
	
	li $v0, 30 
	syscall #ejecuto funcion de obtener tiempo
	sub $a0, $a0, $s7 #resto los dos tiempos
	li $v0, 1
	syscall #los muestro
	
	bne $s3, $zero, set
	
	#close file
	li $v0, 16
	move $a0, $s6
	syscall
	#close file
	li $v0, 16
	move $a0, $s5
	syscall
	
