
	.data
fout: .asciiz "pilas2.txt" 
insert_out: .asciiz "qui_aleatorios.txt"
arreglo: .word  1 : 401
buffer: .resb 33
	.text
	
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
	
	
	
quicksort:
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
