.data
array:    .word     0 : 10       # almacenamiento para un arreglo de 10 items
fout: .asciiz "bur_aleatorio.txt" 
coma: .asciiz ", " 
.text
         li       $t0, 10        # $t0 = numero total de items en el arreglo
         subi	  $t4, $t0, 1	 # $t4 = la posici?n del ?ltimo item del arreglo (Para no ponerle coma ya que es el ?ltimo n?mero)
         move     $s0, $zero     # $s0 = indice del arreglo
         move     $t1, $zero     # $t2 = el valor que sera guardado en el arreglo
         
#ABRIR ARCHIVO:
#Aqu? se abre el archivo d?nde se guardar?n los n?meros aleatorios separadaos por comas.
	 li   $v0, 13       # Servicio 13 abre archivos
  	 la   $a0, fout     # $a0 = nombre del archivo
  	 li   $a1, 1        # $a1 = argumento que indica si se escribe o se lee el archivo. 1 es para guardar
  	 li   $a2, 0        # $a2 = argumento que indica el modo. 1 es para ignorar
 	 syscall            # llamar al servicio y abrir.
#####

#DAR FORMATO AL ARCHIVO
#Para darle formato al archivo, hay que agregar comas y espacios tras cada n?mero.
		 j loop_sin_coma #El primer n?mero no necesita una coma que lo preceda as? que se omite este paso
loop_con_coma:	 li   $v0, 15       # Servicio 15 escribe archivos
	  	 la   $a1, coma   # direccion del buffer que tiene la coma y espacio
	  	 li   $a2, 2       # longitud del buffer (hard-coded, coma y espacio son solo 2 caracteres)
	 	 syscall            # llamar al servicio y escribir.
#####
#LAZO:        
#Aqu? comienza el lazo en el que se recorre el arreglo y se le guarda un valor aleatorio.
loop_sin_coma:    sll      $s1, $s0, 2    # Byte Offset. $s1 es la direccion de la posicion a la que apunta el indice. 
         
#GENERACION DE NUMERO ALEATORIO:

	li  $v0, 42             # Servicio 42 pone el limite superior al random
	addi $a1, $zero, 1000  # $a1 = limite superior
	syscall
	add $t1, $a0, $zero     # guarda el numero aleatorio en $t1
#####


#GUARDAR EL NUMERO EN EL ARCHIVO Y EN EL ARREGLO:
#Se guarda el n?mero aleatorio que esta en $t1
	 sw       $t1, array($s1) 	# Guarda el valor aleatorio en el elemento del arreglo
	 li   $v0, 15      		# Servicio 15 escribe archivos
	 addi $t2, $zero, 10 		#$t2 = 10 porque necesito saber si el n?mero a guardar es menor a 10
	 slt  $t3, $t1, $t2 		#$t3 = 1 s?lo si el n?mero a escribir es menor a 10
	 beq $t3, $zero, dos_digitos 	#Si el n?mero a escribir es mayor o igual a 10 se salta el siguiente bloque
	 #Convertir primer digito a ASCII
	 div  $t1, $t2       		# $a0/10
	 mflo $t6           		# $t6 = quotient
	 mfhi $t5           		# $t5 = remainder
	 addi $t5, $t5, 0x30    	# convertir a ASCII en $a1
	 sw $t5, ($sp)			#Guarda el caracter del n?mero en la pila
	 ##
	 move $a1, $sp			#$a1 = direccion del caracter a escribir (sacado de la pila)
	 li   $a2, 1       		# longitud del buffer (hard-coded, un solo digito)
	 syscall            		# llamar al servicio y escribir.
	 
dos_digitos: addi $t2, $zero, 100 	#$t2 = 100 porque necesito saber si el n?mero a guardar es menor a 100
	 slt  $t3, $t1, $t2 		#$t3 = 1 s?lo si el n?mero a escribir es menor a 100
	 beq $t3, $zero, tres_digitos 	#Si el n?mero a escribir es mayor o igual a 100 se salta el siguiente bloque
	 li   $v0, 15      		# Servicio 15 escribe archivos
	 #Convertir primer digito a ASCII
	 addi $t2, $zero, 10 		#$t2 = 10
	 div  $t6, $t2       		# $cociente anterior/10
	 mflo $t6           		# $t6 = quotient
	 mfhi $t5          		# $t5 = remainder
	 addi $t5, $t5, 0x30    	# convertir a ASCII en $a1
	 sw $t5, ($sp)			#Guarda el caracter del n?mero en la pila
	 ##
	 move $a1, $sp			#$a1 = direccion del caracter a escribir (sacado de la pila)	
	 li   $a2, 1       		# longitud del buffer (hard-coded, un solo digito)
	 syscall
tres_digitos: li   $v0, 15      	# Servicio 15 escribe archivos
	 addi $t5, $t5, 0x30    	# convertir a ASCII en $a1
	 sw $t5, ($sp)			#Guarda el caracter del n?mero en la pila
	 ##
	 move $a1, $sp			#$a1 = direccion del caracter a escribir (sacado de la pila)
	 li   $a2, 1       		# longitud del buffer (hard-coded, un solo digito)
	 syscall
#CONTROL DE LAZO:
#Si nos pasamos del rango del arreglo, se acab? el programa. El indice del arreglo est? en $s0.

	addi $s0, $s0, 1
	beq $s0, $t4, loop_con_coma
	bne $s0, $t0, loop_sin_coma
	
# FIN DEL LAZO
         li       $v0, 10        # servicio n?mero 10 es salir
         syscall                 # llamar al servicio y terminar programa