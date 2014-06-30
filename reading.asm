
	.data
fout: .asciiz "aleatorios.txt" 
foutbub: .asciiz "bur_aleatorios.txt" 
foutins: .asciiz "ins_aleatorios.txt" 
foutqui: .asciiz "qui_aleatorios.txt"
bubtimes: .asciiz "bur_tiempos.txt" 
instimes: .asciiz "ins_tiempos.txt" 
quitimes: .asciiz "qui_tiempos.txt"
menu: .asciiz "0) Bubble Sort\n1)Insertion Sort\n2)Quicksort"
arreglo: .word  1 : 401
op: .word 1
buffer: .resb 33
	.text
	li $v0, 51	#instruccion para recibir un int como input
	la $a0, menu	# imprimir las opciones del menu en pantalla
	syscall
	add $t7, $zero, $a0	#0 para bubble sort, 1 para insert sort, 2 para quicksort
	li $s3, 10
	beq $t7, $zero, bubtim
	li $t1, 1
	beq $t7, $t1, instim
	li $t2,2
	beq $t7, $t2, quitim
quitim:	##############archivo de tiempos###################
	# open file
	li $v0, 13 #instruccion abrir archivo
	la $a0, quitimes #parametro nombre
	li $a1, 1
	li $a2, 0
	syscall #llamo a la instrucción
	move $s4, $v0 #guardo el registro de información del archivo en s4
	###################################################
	beq $zero, $zero, conti	
bubtim:	##############archivo de tiempos###################
	# open file
	li $v0, 13 #instruccion abrir archivo
	la $a0, bubtimes #parametro nombre
	li $a1, 1
	li $a2, 0
	syscall #llamo a la instrucción
	move $s4, $v0 #guardo el registro de información del archivo en s4
	###################################################
	beq $zero, $zero, conti
instim:	##############archivo de tiempos###################
	# open file
	li $v0, 13 #instruccion abrir archivo
	la $a0, instimes #parametro nombre
	li $a1, 1
	li $a2, 0
	syscall #llamo a la instrucción
	move $s4, $v0 #guardo el registro de información del archivo en s4
	###################################################
	beq $zero, $zero, conti
conti:	# open file
	li $v0, 13 #instruccion abrir archivo
	la $a0, fout #parametro nombre
	li $a1, 0
	li $a2, 0
	syscall #llamo a la instrucción
	move $s6, $v0 #guardo el registro de información del archivo en s6
	# open file
	li $v0, 13 #instruccion abrir archivo
	la $a0, foutbub #parametro nombre
	beq $t7, $zero, bubble1
	la $a0, foutqui #param quicksort
	
	beq $t7,$t2, bubble1
	la $a0, foutins 
bubble1: 
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

	beq $zero, $zero, loop3 #regreso al loop de sacar numeros
salSls:
	
	beq $t7, $zero, bubble_start
	li $t9,2
	beq $t7,$t9 , quicksort
	j insert_sort	
bubble_start:	#BubbleSort
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
	#Fin de BubbleSort
	bne $t7, $zero, insert_sort
	j imp
	#INSERTION SORT
insert_sort:
	add $s2, $zero, $t0	# $s2 = numero de elementos a organizar
	addi $t0, $t0, 1	# $t0 = longitud del arreglo + 1 (Porque el indice comienza dezde 1)
	li $s1, 2		# $s1 = indice del primer elemento sin ordenar
lazo_for:
	beq 	$t0, $s1, imp	# Si el indice incrementa hasta la longitud del arreglo se termina el lazo
	subi 	$s4, $s1, 1		# $s4 = indice de prueba
	sll	$s0, $s1, 2		# $s0 = direccion a la que apunta el indice sin ordenar. Desplazar a la izq 2 veces para byte offset
	lw	$t1, arreglo($s0)	# $t1 = elemento a insertar
lazo_while:
	beq 	$s4, $zero, fin_del_wh	# Si el indice de prueba es menor a cero se acaba el while
	sll	$s0, $s4, 2		# $s0 = direccion a la que apunta el indice de prueba. Desplazar a la izq 2 veces para byte offset
	lw	$t2, arreglo($s0)	# $t2 = elemento de prueba
	ble	$t2, $t1, fin_del_wh	# Si el elemento de prueba es menor o igual al elemento a insertar se termina el while
	addi 	$s0, $s4, 1		# $s0 = indice que es mayor por una unidad al indice de prueba
	sll	$s0, $s0, 2		# Byte offset
	sw	$t2, arreglo($s0)	# Se guarda el elemento de prueba en la posicion + 1
	subi	$s4, $s4, 1		# Resto 1 al indice de prueba
	j	lazo_while		# Regreso al inicio del while
fin_del_wh:
	addi 	$s0, $s4, 1		# $s0 = indice que es mayor por una unidad al indice de prueba
	sll	$s0, $s0, 2		# Byte offset
	sw	$t1, arreglo($s0)	# Se guarda el elemento a insertar en la posicion de prueba + 1
	addi	$s1, $s1, 1		# Indice de elemento sin ordenar + 1
	j	lazo_for		# Regresar al inicio del for
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
	
#DAR FORMATO AL ARCHIVO INSERT SORT:
#Para darle formato al archivo, hay que agregar enters y espacios tras cada n?mero.
	 	 addi   $s2, $s2, 2	# se le suma 1 a $s2 porque el indice comienza en en 1
		 addi	$s1, $zero, 1	# $s1 indice del arreglo
		 j	loop_sin_coma	#El primer n?mero no necesita una enter que lo preceda as? que se omite este paso
loop_con_coma:	 li	$v0, 15       	# Servicio 15 escribe archivos
		 move	$a0, $s5      	# file descriptor
		 li 	$t5, ','	# $t5 = la coma
	 	 sw 	$t5, ($sp)	# Guarda la coma en la pila
	 	 move	$a1, $sp	# Mover de la pila al argumento del syscall
	  	 li   	$a2, 1       	# longitud del buffer (hard-coded, solo un caracter)
	 	 syscall            	# llamar al servicio y escribir.
	 	 li	$v0, 15       	# Servicio 15 escribe archivos
		 move	$a0, $s5      	# file descriptor
		 li 	$t5, ' '	# $t5 = la coma
	 	 sw 	$t5, ($sp)	# Guarda la coma en la pila
	 	 move	$a1, $sp	# Mover de la pila al argumento del syscall
	  	 li   	$a2, 1       	# longitud del buffer (hard-coded, solo un caracter)
	 	 syscall            	# llamar al servicio y escribir.
#####	
#GUARDAR EL NUMERO EN EL ARCHIVO SORT:
#Se guarda el n?mero aleatorio que esta en $t1
loop_sin_coma:
	 sll	$s0, $s1, 2		# $s0 = apunta a la direccion de s1 (Byte offset)
	 lw     $t1, arreglo($s0) 	# Carga el valor en el elemento del arreglo
	 
	 #Loop para convertir digitos a ASCII
	 addi $t4, $zero, 3		# $t4 = contador para 3 iteraciones (Inicia en 3)
	 add $t6, $zero, $t1		#$t6 = el cociente del numero aleatorio en cada iteracion
ascii_loop: addi $t2, $zero, 10 	#$t2 = 10 porque necesito dividir para 10 para sacar cada caracter 
	 div  $t6, $t2       		# $t1/10
	 mflo $t6           		# $t6 = quotient
	 mfhi $t5           		# $t5 = remainder
	 addi $t5, $t5, 0x30    	# convertir a ASCII en $a1
	 sw $t5, ($sp)			#Guarda el caracter del n?mero en la pila
	 addi $sp, $sp, 4 		#avanzo en la pila
	 subi $t4, $t4, 1		#Resta 1 al contador
	 bne $t4, $zero, ascii_loop	#Si el contador es 0 sale del loop
	 
	 #Loop para escribir digitos
	 addi $t4, $zero, 3		# $t4 = contador para 3 iteraciones (Inicia en 3)
	 #Ajustar contador para cuando solo necesito 2 iteraciones
	 addi $t3, $zero, 100		# $t3 = 100 para saber si el numero tiene menos de dos digitos
	 slt $t2, $t1, $t3		# $t2 = 1 si el aleatorio es menor a 100
	 beq $t2, $zero, write_loop	# Si el aleatorio es mayor a 100, comienza el loop con normalidad
	 subi $t4, $t4, 1		# Se decrementa en 1 el contador ya que si es menor a 100 solo necesita dos caracteres
	 subi $sp, $sp, 4 		#retrocedo en la pila para ignorar el cero a la izquierda
	 #Ajustar contador para cuando solo necesito 1 iteracion
	 addi $t3, $zero, 10		# $t3 = 10 para saber si el numero tiene menos de dos digitos
	 slt $t2, $t1, $t3		# $t2 = 1 si el aleatorio es menor a 10
	 beq $t2, $zero, write_loop	# Si el aleatorio es mayor a 10, comienza el loop con normalidad
	 subi $t4, $t4, 1		# Se decrementa en 1 el contador ya que si es menor a 10 solo necesita un caracter
	 subi $sp, $sp, 4 		#retrocedo en la pila para ignorar el cero a la izquierda
write_loop: li   $v0, 15      		# Servicio 15 escribe archivos
	 move $a0, $s5      		# file descriptor 
	 subi $sp, $sp, 4 		#retrocedo en la pila
	 move $a1, $sp			#$a1 = direccion del caracter a escribir (sacado de la pila)
	 li   $a2, 1       		# longitud del buffer (hard-coded, un solo digito)
	 syscall            		# llamar al servicio y escribir.
	 subi $t4, $t4, 1		#Resta 1 al contador
	 bne $t4, $zero, write_loop	#Si el contador es 0 sale del loop
	 
#CONTROL DE LAZO:
#Si nos pasamos del rango del arreglo, se acab? el programa. El indice del arreglo est? en $s0.

write_end: addi $s1, $s1, 1
	   bne $s1, $s2, loop_con_coma
	
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
	#####################   Grabar los tiempos #####################################
	#grabar el numero
	addi $sp, $sp, -16 #desplazo 3*4 bytes la pila
	addi $t4, $zero, 4 #contador for
	addi $sp, $sp, 4 #avanzo en la pila
	
loopt:	addi $t0, $zero, 10
	div  $a0, $t0       # $a0/10
	mflo $a1           # $a1 = quotient
	mfhi $t0           # $t0 = remainder
	addi $a0, $t0, 0x30    # convert to ASCII
	add $t2, $a0, $zero	#cargo en t2 el residuo en ascii
	sw $t2, ($sp)	#guardo t2 en la pila
	
	addi $sp, $sp, 4
	add $a0, $a1, $zero
	bne $a0, $zero, loopt
	#Grabar numeros
lopsav:	addi $sp, $sp, -4 #me desplazo 4 bytes hacia abajo en la pila para el primer digito
	#write file
	li $v0, 15 #instruccion write
	move $a0, $s4 #cargo la descripcion del archivo que tenia guardada en s6
	move $a1, $sp #pongo  el valor del digito en ascii como parametro
	li $a2, 1 
	syscall #exporto el num al archivo
	subi $t4, $t4, 1
	bne $t4, $zero, lopsav
	la $t9, buffer #cargo buffer
	li $t4, 32 #espacio
	sw $t4, buffer #agrego el backslash al buffer
	#write file
	li $v0, 15 #instruccion write
	move $a0, $s4 #cargo la descripcion del archivo que tenia guardada en s4
	move $a1, $t9 #pongo  el valor del digito en ascii como parametro
	li $a2, 1
	syscall 

	
	###############################################################################
	bne $s3, $zero, set
	
	
	

	

	#----------------------------------------------------------------------
#    QUICKSORT

li $s0, 0 #indice del arreglo
addi $s1, $s0, 4
addi $s2, $s1, 4

lw $a0, arreglo($s0)
lw $a1, arreglo($s0)
lw $a2, arreglo($s2)

#----------------------------------------------------------------------
#    # $a0 = pivot/inicio del arreglo, $a1 = left, $a2 = right
#----------------------------------------------------------------------
QUICKSORT:




bubble_start:	#BubbleSort
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
	
	
	
    addi $t0, $a1, 1         # t0 = i = left + 1
    add $t1, $a2, $zero      # t1 = j = right

    #----------------------------------------------------------------------
    # if(left > right)return;
    #----------------------------------------------------------------------
    sub $t2, $t1, $t0        # t2 = right - left
    slti $t3, $t2, 0         # t3 = ?(t2 < 0)
    beq $t3, $zero, loopq1    # if t3 >= 0 then goto loopq1
    
    jr $ra                   # return

#----------------------------------------------------------------------
#    while( 1 )
#----------------------------------------------------------------------
loopq1:                       # while(1)
    sll $t2, $a1, 2          # t2 = left * 4
    add $t2, $t2, $a0        # t2 = &array[left]
    lw $t3, arreglo($t2)           # t3 = array[left]

#----------------------------------------------------------------------
#    while( array[i] < array[left] && i < right+1)i++;
#----------------------------------------------------------------------
loopq2:                 
    sll $t2, $t0, 2          # t2 = i * 4
    add $t2, $t2, $a0        # t2 = &array[i]
    lw $t4, arreglo($t2)           # t4 = array[i]

    #----------------------------------------------------------------------
    # if( array[i] >= array[left] ) then goto loopq3
    #----------------------------------------------------------------------
    sub $t2, $t4, $t3        # t2 = arrat[i] - array[left]
    slti $t5, $t2, 0         # t5 = ?(t2 < 0)
    bne $t5, $zero, loopq3    # if t5 != 0 then goto loopq3

    #----------------------------------------------------------------------
    # if( i >= (right+1) ) then goto loopq3
    #----------------------------------------------------------------------
    addi $t5, $a2, 1         # t5 = right + 1
    sub $t2, $t0, $t5        # t2 = i - 5
    slti $t5, $t2, 0         # t5 = ?(t2 < 0)
    bne $t5, $zero, loopq3    # if t5 != 0 then goto loopq3
  
    addi $t0, $t0, 1         # i++
    j loopq2                  # goto loopq2

#----------------------------------------------------------------------
#    while( array[j] > array[left] && j > left-1)j--;
#----------------------------------------------------------------------
loopq3:
    sll $t2, $t1, 2          # t2 = j * 4
    add $t2, $t2, $a0        # t2 = &array[j]
    lw $t4, arreglo($t2)           # t4 = array[j]

    #----------------------------------------------------------------------
    # if( array[j] <= array[left] ) then goto Bloop
    #----------------------------------------------------------------------
    sub $t2, $t4, $t3        # t2 = arrat[j] - array[left]
    slti $t5, $t2, 0         # t5 = ?(t2 < 0)
    beq $t5, $zero, Bloop    # if t5 = 0 then goto Bloop

    #----------------------------------------------------------------------
    # if( j <= (left-1) ) then goto Bloop
    #----------------------------------------------------------------------
    subi $t5, $a1, 1         # t5 = left - 1
    sub $t2, $t1, $t5        # t2 = j - t5
    slti $t5, $t2, 0         # t5 = ?(t2 < 0)
    beq $t5, $zero, Bloop    # if t5 = 0 then goto Bloop
  
    addi $t1, $t1, -1        # j--
    j loopq3                  # goto loopq3

Bloop:
    #----------------------------------------------------------------------
    # Do Swap
    #----------------------------------------------------------------------
    addi $sp, $sp, -20       # Make 5 words STACK
    sw $ra, 16($sp)          #
    sw $a0, 12($sp)          #
    sw $a1, 8($sp)           #
    sw $t0, 4($sp)           #
    sw $t1, 0($sp)           #

    add, $a1, $a0, $t1       # a1 = array + j
    add, $a0, $a0, $t0       # a0 = array + i
    jal SWAP                 # Call SWAP

    lw $t1, 0($sp)           #
    lw $t0, 4($sp)           #
    lw $a1, 8($sp)           #
    lw $a0, 12($sp)          #
    lw $ra, 16($sp)          #
    addi $sp, $sp, 20        # Clear STACK


    j loopq1                  # goto loopq1

    #----------------------------------------------------------------------
    # Do Swap
    #----------------------------------------------------------------------
    addi $sp, $sp, -20       # Make 5 words STACK
    sw $ra, 16($sp)          #
    sw $a0, 12($sp)          #
    sw $a1, 8($sp)           #
    sw $t0, 4($sp)           #
    sw $t1, 0($sp)           #

    add, $a1, $a0, $t1       # a1 = array + j
    add, $a0, $a0, $a1       # a0 = array + left
    jal SWAP                 # Call SWAP

    lw $t1, 0($sp)           #
    lw $t0, 4($sp)           #
    lw $a1, 8($sp)           #
    lw $a0, 12($sp)          #
    lw $ra, 16($sp)          #
    addi $sp, $sp, 20        # Clear STACK

Recursive:
    #----------------------------------------------------------------------
    # Quicksort Left
    #----------------------------------------------------------------------
    addi $sp, $sp, -20       # Make 5 words STACK
    sw $ra, 16($sp)          #
    sw $a0, 12($sp)          #
    sw $a1, 8($sp)           #
    sw $a2, 4($sp)           #
    sw $t1, 0($sp)           #

    add $a2, $t1, -1         # a2 = j - 1
    jal QUICKSORT            # Call QUICKSORT(array, left, j-1 )

    lw $t1, 0($sp)           #
    lw $a2, 4($sp)           #
    lw $a1, 8($sp)           #
    lw $a0, 12($sp)          #
    lw $ra, 16($sp)          #
    addi $sp, $sp, 20        # Clear STACK

    #----------------------------------------------------------------------
    # QuickSort Right
    #----------------------------------------------------------------------
    addi $sp, $sp, -20       # Make 5 words STACK
    sw $ra, 16($sp)          #
    sw $a0, 12($sp)          #
    sw $a1, 8($sp)           #
    sw $a2, 4($sp)           #
    sw $t1, 0($sp)           #

    add $a1, $t1, 1          # a1 = j + 1
    jal QUICKSORT            # Call QUICKSORT(array, j+1, right )

    lw $t1, 0($sp)           #
    lw $a2, 4($sp)           #
    lw $a1, 8($sp)           #
    lw $a0, 12($sp)          #
    lw $ra, 16($sp)          #
    addi $sp, $sp, 20        # Clear STACK

    jr $ra                   # return

#----------------------------------------------------------------------
#    Swap Function
#
#    a0 = &a, a1 = &b
#----------------------------------------------------------------------
SWAP:
    lw $t0, 0($a0)           #
    lw $t1, 0($a1)           #
    sw $t1, 0($a0)           #
    sw $t0, 0($a1)           #
    jr $ra                   # return
	#close file
	li $v0, 16
	move $a0, $s6
	syscall


	
	
	#close file
	li $v0, 16
	move $a0, $s6
	syscall
	#close file
	li $v0, 16
	move $a0, $s5
	syscall
	#close file
	li $v0, 16
	move $a0, $s4
	syscall
	
