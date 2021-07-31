#Nome: Vitor G. S. Ruffo | #Atividade 12.1

.data
	msg1: .asciiz "Insira o numero de elementos do vetor:\n"
	msg2: .asciiz "\nVetor:\n"
	msg3: .asciiz "\nvetor["
	msg4: .asciiz "] = "
	msg5: .asciiz "\n\nO numero "
	msg6: .asciiz " ocorre "
	msg7: .asciiz " vez(es)\n"
	
.text
	main:
		la $a0, msg1
		jal ler_n
		addi $s1, $v0, 0 #s1 = tamanho do vetor.
		
		addi $s2, $zero, 8 #s2 = tamanho de um elemento do vetor (bytes) = 8 bytes.
		
		addi $a0, $s1, 0 
		addi $a1, $s2, 0 
		jal alocar_vetor #alocar_vetor(tamanhoVetor:int, tamanhoElemento:int):address
		la $s0, ($v0)
		
		la $a0, ($s0)
		addi $a1, $s1, 0
		addi $a2, $s2, 0
		jal ler_vetor #ler_vetor(vetor:address, tamanhoVetor:int, tamanhoElemento:int):void
		
		la $a0, ($s0)
		addi $a1, $s1, 0
		addi $a2, $s2, 0
		jal imprimir_vetor #imprimir_vetor(vetor:address, tamanhoVetor:int, tamanhoElemento:int):void
		
		la $a0, ($s0)
		addi $a1, $s1, 0
		addi $a2, $s2, 0
		jal gnome_sort_double #gnome_sort(vetor:address, tamanho:int, tamanhoElemento:int):void
		
		addi $t7, $zero, 1 #t7 (contador) = 1
		addi $t0, $zero, 0 #t0 (i) = 0
		mtc1 $zero, $f6 #$f6 = zero constant = 0 
		
		main_loop:
			mult $t0, $s2 
			mflo $t1 #t1 = tamanhoElemento * i (i.e, deslocamento)
			add $t1, $t1, $s0 # t0 = deslocamento + endereço base do vetor (t0 == &vetor[i])
			
			l.d $f2, 0($t1)  #f2 = vetor[i]
			l.d $f4, 8($t1)   #f4 = vetor[i+1]
		
			sub.d $f8, $f4, $f2 #if (f8 == 0 then f2 == f4) (else if f8 > 0 then f2 != f4) 
			c.eq.d $f8, $f6 
    			bc1t incrementar_contador  # if (arr[i] == arr[i+1]) goto incrementar_contador  
			
			apresentar_resultado:
			la $a0, msg5 
			add.d $f12, $f2, $f6  
			jal imprimir_string_seguida_de_double #O numero %lf
			
			la $a0, msg6
			addi $a1, $t7, 0 
			jal imprimir_string_seguida_de_inteiro# ocorre x
	
			addi $v0, $zero, 4
			la $a0, msg7
			syscall  #vez(es).\n
							
			addi $t7, $zero, 1 #t7 (contador) = 1
			j incrementar_i
	
	
			incrementar_contador:
			addi $t7, $t7, 1 
			
			incrementar_i:
			addi $t0, $t0, 1 #i++
			bne $s1, $t0, main_loop #while(i<tamanhoVetor)
			
			
		###########Finalizando o programa############
		addi $v0, $zero, 10
		syscall
		

	ler_n: #(mensagem:string):void
		
		addi $v0, $zero, 4
		syscall		#"exemplo: Insira um valor para N:"
		
		addi $v0, $zero, 5
		syscall
		
		jr $ra #retornando o controle para o chamador
		
		
	alocar_vetor:#(tamanhoVetor:int, tamanhoElemento:int):address
		
		mult $a0, $a1 #
		mflo $a0 #a0 = tamanhoVetor * tamanhoElemento = total de bytes do vetor
		
		addi $v0, $zero, 9
		syscall #aloca a0 bytes e guarda o endereço do inicio do bloco em v0.
		
		jr $ra #retornando o controle para o chamador	
		
		
	ler_vetor: #((a0) vetor:address, (a1) tamanhoVetor:int, (a2) tamanhoElemento:int):void
	
		addi $sp, $sp, -12 #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		add $s0, $a1, $zero #s0 = tamanho do vetor
		la $s1, ($a0) # s1 = endereço base do vetor
		addi $s2, $zero, 0 # i = 0 
		
		
		addi $v0, $zero, 4
		la $a0, msg2
		syscall	#"Vetor:"
				 	     
		leitura:
			mult $s2, $a2
			mflo $t0 # t0 = tamanhoElemento * i (i.e, deslocamento)
			add $t0, $t0, $s1 # t0 = deslocamento + endereço base do vetor (t0 == &vetor[i])
			
			addi $v0, $zero, 4
			la $a0, msg3
			syscall  #imprimir: vetor[
			
			addi $v0, $zero, 1
			add $a0, $zero, $s2
			syscall  #imprimir: i
			
			addi $v0, $zero, 4
			la $a0, msg4
			syscall   #imprimir: ] = 
			
			addi $v0, $zero, 7
			syscall	# ler: vetor[i]
			s.d $f0, ($t0)#guardar o valor lido em vetor[i]
				
			addi $s2, $s2, 1 # i++
			bne $s2, $s0, leitura # while(i < numero de elementos do vetor)
		
		lw $s0, 0($sp)  #guardando os valores originais de volta em s0/s1/s2
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12 #desempilhando s0/s1/s2  
		jr $ra #retornando o controle para o chamador
	
	
	imprimir_vetor:#(vetor:address, tamanhoVetor:int, tamanhoElemento:int):void
	
		addi $sp, $sp, -24 #armazenando valores de s0/t0-t3/ra na pilha
		sw $s0, 0($sp)
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		sw $t2, 12($sp)
		sw $t3, 16($sp)
		sw $ra, 20($sp)
						
		la $t0, ($a0) # t0 = endereço base do vetor
		addi $s0, $a1, 0 #s0 = tamanho do vetor
		addi $t2, $zero, 0 # i = 0
		
		addi $v0, $zero, 4
		la $a0, msg2
		syscall  #Vetor:
		
		print_loop:
			mult $t2, $a2
			mflo $t3	# t3 = tamanhoElemento * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i])	
			
			l.d $f12, ($t3)
			
			la $a0, msg3 
			add $a1, $t2, $zero 
			jal imprimir_string_seguida_de_inteiro #vetor[i
			
			la $a0, msg4 
			jal imprimir_string_seguida_de_double#]=x
			
			addi $t2, $t2, 1 #i++
			bne $s0, $t2, print_loop #while(i<tamanhoVetor)
		
		lw $s0, 0($sp) #guardando os valores originais de volta em s0/t0-t3/ra
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp, 24 #desempilhando s0/t0-t3/ra 
		jr $ra #retornando o controle para o chamador
	
	
	imprimir_string_seguida_de_inteiro: #(a0:string, a1:int):void

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 
		jr $ra #retornando o controle para o chamador
		

	imprimir_string_seguida_de_double: #(a0:string, f12:double):void

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 3
		syscall 
		jr $ra #retornando o controle para o chamador
		
		
	gnome_sort_double: #(vetor:address, tamanhoVetor:int, tamanhoElemento:int):void

		addi $sp, $sp, -8
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		
		la $t0, ($a0) #t0 = endereço base
		addi $t1, $a1, 0 #t1 = tamanho vetor
		addi $v0, $zero, 0, #i = 0
		
		mult $t1, $a2         #t1 *= tamanhoElemento -> t1 vai passar a guardar a quantidade de bytes necessarios para guardar "tamanhoVetor" elementos. e.g, tamanhoVetor == 16 elementos, ..., t1 = 16 *  tamanhoElemento bytes
  		mflo $t1
  		
  		loop_gnome:
   	 		slt $t3, $v0, $t1        # if (i < n) => $t3 = 1
    			beq $t3, $zero, fim_gnome      # while (i < n) {
    			bne $v0, $zero, comparar_gnome  # if (i == 0)
    			addu $v0, $v0, $a2          # i = i + 1
  		
  			comparar_gnome:
    			addu $t2, $t0, $v0        # $t2 = endereço base + deslocamento em bytes (=&arr[i])
    			l.d $f2, -8($t2)         # $f2 = arr[i-1]
    			l.d $f4, 0($t2)          # $f4 = arr[i]
    			c.lt.d $f4, $f2
    			bc1t swap_gnome  # swap if (arr[i] < arr[i-1])       
    			addu $v0, $v0, $a2          # i = i + 1
    			j loop_gnome
  		
  			swap_gnome:
    			s.d $f2, 0($t2)          # swap (arr[i], arr[i-1])
    			s.d $f4, -8($t2)
    			subu $v0, $v0, $a2         # i = i - 1
    			j loop_gnome
  		
  		fim_gnome:
   		lw $t0, 0($sp)
   		lw $t1, 4($sp)           
  	 	addi $sp, $sp, 8           
   		jr $ra	
