.data
array:    .word     0 : 10       # almacenamiento para un arreglo de 10 items
fout: .asciiz "bur_aleatorio.txt" 
.text
         li       $t0, 20        # $t0 = numero total de items en el arreglo
         move     $s0, $zero     # $s0 = indice del arreglo
         move     $t1, $zero     # $t1 = el valor que sera guardado en el arreglo
         
#ABRIR ARCHIVO:
#Aqu? se abre el archivo d?nde se guardar?n los n?meros aleatorios separadaos por enters.
	 li   $v0, 13       # Servicio 13 abre archivos
  	 la   $a0, fout     # $a0 = nombre del archivo
  	 li   $a1, 1        # $a1 = argumento que indica si se escribe o se lee el archivo. 1 es para guardar
  	 li   $a2, 0        # $a2 = argumento que indica el modo. 1 es para ignorar
 	 syscall            # llamar al servicio y abrir.
 	 move $s6, $v0      # Guardar file descriptor
#####

#DAR FORMATO AL ARCHIVO
#Para darle formato al archivo, hay que agregar enters y espacios tras cada n?mero.
		 j loop_sin_enter #El primer n?mero no necesita una enter que lo preceda as? que se omite este paso
loop_con_enter:	 li   $v0, 15       # Servicio 15 escribe archivos
		 move $a0, $s6      # file descriptor 
	  	 la   $a1, enter   # direccion del buffer que tiene la enter y espacio
	  	 li   $a2, 2       # longitud del buffer (hard-coded, enter y espacio son solo 2 caracteres)
	 	 syscall            # llamar al servicio y escribir.
	 	 .data
	  	 enter: .asciiz ", "
		 .text
#####
#LAZO:        
#Aqu? comienza el lazo en el que se recorre el arreglo y se le guarda un valor aleatorio.
loop_sin_enter:    sll      $s1, $s0, 2    # Byte Offset. $s1 es la direccion de la posicion a la que apunta el indice. 
         
#GENERACION DE NUMERO ALEATORIO:

	li  $v0, 42             # Servicio 42 pone el limite superior al random
	addi $a1, $zero, 1000  # $a1 = limite superior
	syscall
	add $t1, $a0, $zero     # guarda el numero aleatorio en $t1
#####


#GUARDAR EL NUMERO EN EL ARCHIVO Y EN EL ARREGLO:
#Se guarda el n?mero aleatorio que esta en $t1
	 sw       $t1, array($s1) 	# Guarda el valor aleatorio en el elemento del arreglo
	 
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
	 move $a0, $s6      		# file descriptor 
	 subi $sp, $sp, 4 		#retrocedo en la pila
	 move $a1, $sp			#$a1 = direccion del caracter a escribir (sacado de la pila)
	 li   $a2, 1       		# longitud del buffer (hard-coded, un solo digito)
	 syscall            		# llamar al servicio y escribir.
	 subi $t4, $t4, 1		#Resta 1 al contador
	 bne $t4, $zero, write_loop	#Si el contador es 0 sale del loop
	 
#CONTROL DE LAZO:
#Si nos pasamos del rango del arreglo, se acab? el programa. El indice del arreglo est? en $s0.

write_end: addi $s0, $s0, 1
	bne $s0, $t0, loop_con_enter
	
# FIN DEL LAZO
	  # Close the file 
  	 li   $v0, 16       # system call for close file
  	 move $a0, $s6      # file descriptor to close
  	 syscall            # close file
         li       $v0, 10        # servicio n?mero 10 es salir
         syscall                 # llamar al servicio y terminar programa
