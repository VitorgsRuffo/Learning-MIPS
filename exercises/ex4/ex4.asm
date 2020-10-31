#Nome: Vitor G. S. Ruffo | #ex4

.data
	vet:
	msg1: .asciiz "Leitura de Vetor:\nInsira o numero de elementos:\n"
	msg2: .asciiz "\nvetor["
	msg3: .asciiz "] = "
	msg4: .asciiz "\nElementos do vetor:\n"
	
	msg5: .asciiz "\n\nNumero de elementos primos do vetor: "
	msg6: .asciiz "\n\nNumero de elementos perfeitos do vetor: "

	msg7: .asciiz "\n\nNumero de amigos no vetor: "
	msg8: .asciiz "\n\nOs numeros "
	msg9: .asciiz " e "
	msg10: .asciiz " sao amigos!"

.text
	main:
		
		##############Lendo o vetor##################
		jal ler_vetor
		addi $s0, $v0, 0 #recebendo o numero de elementos lidos
		
		
		#############Imprimindo vetor################
		la $t0, vet # endereço base do vetor
		addi $t2, $zero, 0 # i = 0
		
		addi $v0, $zero, 4
		la $a0, msg4
		syscall  #Elementos do vetor:
		print_loop:
			sll $t3, $t2, 2 # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i)	
			
			lw $t1, 0($t3)
			
			la $a0, msg2 
			add $a1, $t2, $zero 
			jal imprimir_string_seguida_de_inteiro
			la $a0, msg3 
			add $a1, $t1, $zero 
			jal imprimir_string_seguida_de_inteiro
			
			addi $t2, $t2, 1 #i++
			bne $s0, $t2, print_loop
		
		
		###############Numero de Primos###############
		
		la $a0, vet #passando o endereço base do vetor como parametro
		addi $a1, $s0, 0  #passando o numero de elementos do vetor como parametro
		la $a2, o_numero_e_primo #passando o endereço do teste a ser executado em cada elemento
		jal numero_elementos_x_vetor
		addi $s1, $v0, 0  #recebendo o numero de elementos primos do vetor.
		
		la $a0, msg5 #passando a string a ser printada como parametro
		addi $a1, $s1, 0 #passando o inteiro a ser printado como parametro
		jal imprimir_string_seguida_de_inteiro
						
							
		#############Numero de Perfeitos#############
		
		la $a0, vet #passando o endereço base do vetor como parametro
		addi $a1, $s0, 0  #passando o numero de elementos do vetor como parametro
		la $a2, o_numero_e_perfeito #passando o endereço do teste a ser executado em cada elemento
		jal numero_elementos_x_vetor
		addi $s2, $v0, 0  #recebendo o numero de elementos perfeitos do vetor.
		
		la $a0, msg6 #passando a string a ser printada como parametro
		addi $a1, $s2, 0 #passando o inteiro a ser printado como parametro
		jal imprimir_string_seguida_de_inteiro
		
		
		#############Numero de Amigos################
		
		la $a0, vet #passando o endereço base do vetor como parametro
		addi $a1, $s0, 0  #passando o numero de elementos do vetor como parametro
		jal numero_elementos_amigos_vetor
		addi $s3, $v0, 0 #recebendo o numero de elementos amigos do vetor.
		
		la $a0, msg7 #passando a string a ser printada como parametro
		addi $a1, $s3, 0 #passando o inteiro a ser printado como parametro
		jal imprimir_string_seguida_de_inteiro
				
				
		###########Finalizando o programa############
		addi $v0, $zero, 10
		syscall
		
		
	ler_vetor:
		addi $sp, $sp, -12 #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		addi $v0, $zero, 4
		la $a0, msg1
		syscall	# imprimir: Leitura de Vetor:
			# 	    Insira o numero de elementos:
		
		addi $v0, $zero, 5
		syscall	# ler: numero de elementos
		add $s0, $v0, $zero #guardar o valor lido em $s0
		
		la $s1, vet # endereço base do vetor
		add $s2, $zero, $zero # i = 0 
		
		leitura:
			sll $t0, $s2, 2 # t0 = 4 * i (i.e, deslocamento)
			add $t0, $t0, $s1 # t0 = deslocamento + endereço base do vetor (t0 == &vetor[i)
			
			addi $v0, $zero, 4
			la $a0, msg2
			syscall  #imprimir: vetor[
			
			addi $v0, $zero, 1
			add $a0, $zero, $s2
			syscall  #imprimir: i
			
			addi $v0, $zero, 4
			la $a0, msg3
			syscall   #imprimir: ] = 
			
			addi $v0, $zero, 5
			syscall	# ler: vetor[i]
			sw $v0, 0($t0) #guardar o valor lido em vetor[i]
			
			addi $s2, $s2, 1 # i++
			bne $s2, $s0, leitura # while(i < numero de elementos do vetor)

		add $v0, $s0, $zero #retornando o numero de elementos lidos para o caller
		
		lw $s0, 0($sp)  #guardando os valores originais de volta em s0/s1/s2
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12 #desempilhando s0/s1/s2  
		jr $ra #retornando o controle para o chamador
	
	
	imprimir_string_seguida_de_inteiro: #(a0 = string, a1 = inteiro )

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 
		jr $ra #retornando o controle para o chamador
	
	
	numero_elementos_x_vetor: #(a0 = endereço base do vetor, a1 = tamanho do vetor, a2 = x [endereço do inicio do procedimento que diz se um numero é classificado como x ou nao])
	
		addi $sp, $sp, -16 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		sw $s1, 4($sp) #
		sw $s2, 8($sp) #
		sw $ra, 12($sp) ##se vamos chamar um procedimento dentro de outro precisamos salvar o endereço de retorno do chamador, pois, na hora do "jal X" o valor de $ra sera alterado.
		
		la $t0, ($a0) # endereço base do vetor
		addi $s1, $a1, 0 #s1 = tamanho do vetor
		la $s2, ($a2) # s2 = a2
		addi $t1, $zero, 0 # i = 0
		
		addi $s0, $zero, 0 # numero_de_elementos_x = 0
		
		loop_x:
			sll $t2, $t1, 2 # t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &vetor[i])	
			
			lw $t3, 0($t2) #t3 == elemento atual do vetor
			
			#checar se o elemento atual e x. Se sim, incrementar o contador s0. Se nao, jump para inc_i
			
			addi $a0, $t3, 0 #passando o elemento atual do vetor como parametro
			jalr $s2
			addi $t4, $v0, 0 #se o elemento atual for x t4 == 1, se nao t4 == 0
			
			beq $t4, $zero, inc_i # se t4 != 0 incrementamos o contador:
			addi $s0, $s0, 1 # numero_de_elementos_x++
			
		inc_i:	addi $t1, $t1, 1 #i++
			bne $t1, $s1, loop_x #if (i < tamanho do vetor) continuar loop.
	
		add $v0, $s0, $zero #armazenando o valor de retorno (numero de elementos x) em $v0
		lw $s0, 0($sp) 
		lw $s1, 4($sp) 
		lw $s2, 8($sp) 
		lw $ra, 12($sp) 
		addi $sp, $sp, 16
		jr $ra
		
		
	o_numero_e_primo: #(a0 = numero)
		
		addi $sp, $sp, -16
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $t0, 8($sp)
		sw $ra, 12($sp)
		
		addi $s0, $zero, 0, #o_numero_e_primo = 0 
		addi $s1, $zero, 1 #constante1 = 1
		
		beq $a0, $s1, fim_primo #se o numero (a0) for 1 ja sabemos que ele nao e primo
		
		jal soma_dos_divisores
		addi $t0, $v0, 0 #recebendo a soma dos divisores do numero. se o numero for primo a soma de seus divisores deve ser igual a 1 (divisivel por 1 e por ele mesmo (nao consideramos o proprio numero como divisor no procedimento de soma dos divisores))
		
		bne $s1, $t0, fim_primo #se a soma dos divisores for igual a 1, o numero e primo
		addi $s0, $zero, 1 #o_numero_e_primo = 1 	

	fim_primo:
		addi $v0, $s0, 0 #retornando o resultado
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $t0, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		jr $ra
		
		
	o_numero_e_perfeito: #(a0 = numero)
		
		addi $sp, $sp, -20
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $t0, 8($sp)
		sw $t1, 12($sp)
		sw $ra, 16($sp) #se vamos chamar um procedimento dentro de outro precisamos salvar o endereço de retorno do chamador, pois, na hora do "jal X" o valor de $ra sera alterado.
		
		addi $s0, $zero, 0, #o_numero_e_perfeito = 0 
		addi $s1, $a0, 0 #numero = a0
		
		addi $t1, $zero, 1 #constante1 = 1
		beq $s1, $t1, fim_perfeito #se o numero (s1) for 1 ja sabemos que ele nao e perfeito
		
		jal soma_dos_divisores
		addi $t0, $v0, 0 #recebendo a soma dos divisores do numero. Se o numero for perfeito a soma de seus divisores deve ser igual ao numero (desconsiderando o proprio numero como divisor).
		
		bne $s1, $t0, fim_perfeito #se a soma dos divisores for igual ao proprio numero ele e perfeito
		addi $s0, $zero, 1 #o_numero_e_perfeito = 1 	

	fim_perfeito:
		addi $v0, $s0, 0 #retornando o resultado
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $t0, 8($sp)
		lw $t1, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20
		jr $ra
		
	
	numero_elementos_amigos_vetor:  #(a0 = endereço base do vetor, a1 = tamanho do vetor)
		
		addi $sp, $sp, -16
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $ra, 12($sp) ##se vamos chamar um procedimento dentro de outro precisamos salvar o endereço de retorno do chamador, pois, na hora do "jal X" o valor de $ra sera alterado.
		
		la $s0, ($a0) #s0 = endereço base do vetor
		addi $s1, $a1, 0 #s1 = tamanho do vetor
		addi $s2, $zero, 0 #numero_amigos = 0
		addi $t0, $zero, 0 # i = 0
		
		loop_i_amigos: #for(i = 0; i < length(vetor) - 2; i++)
		
			sll $t2, $t0, 2 # t2 = 4 * i (i.e, deslocamento i)
			add $t2, $t2, $s0 # t2 = deslocamento + endereço base do vetor (t2 == &vetor[i])	
			lw $t3, 0($t2) #t3 = elemento i atual do vetor (t3 = vetor[i])
			
			addi $a0, $t3, 0
			jal soma_dos_divisores 
			addi $t5, $v0, 0 #t5 = somaDosDivisores(t3);
			
			addi $t1, $t0, 1 # j = i + 1
			loop_j_amigos: #for(j = i + 1; j < length(vetor) - 1; j++)
				 
				sll $t2, $t1, 2 # t2 = 4 * j (i.e, deslocamento j)
				add $t2, $t2, $s0 # t2 = deslocamento + endereço base do vetor (t2 == &vetor[j])	
				lw $t4, 0($t2) #t4 = elemento j atual do vetor (t4 = vetor[j])
				
				addi $a0, $t4, 0
				jal soma_dos_divisores
				addi $t6, $v0, 0 #t6 = somaDosDivisores(t4);
				
				sub $t7, $t5, $t4 # t7 = somaDosDivisores(vetor[i]) - vetor[j]
				sub $t8, $t6, $t3 # t8 = somaDosDivisores(vetor[j]) - vetor[i]
				
				bne $t7, $zero, inc_j_amigos # as duas subtraçoes acima precisam resultar em zero para que a expressao
				bne $t8, $zero, inc_j_amigos # (somaDosDivisores(vetor[i]) == vetor[j] && somaDosDivisores(vetor[j]) == vetor[i]) seja verdadeira
				
				#printf("t3 e t4 sao amigos!");
				addi $v0, $zero, 4
				la $a0, msg8
				syscall
				
				addi $v0, $zero, 1
				addi $a0, $t3, 0
				syscall
				
				addi $v0, $zero, 4
				la $a0, msg9
				syscall
				
				addi $v0, $zero, 1
				addi $a0, $t4, 0
				syscall
				
				addi $v0, $zero, 4
				la $a0, msg10
				syscall
			
				addi $s2, $s2, 1 #numero_amigos++
					
				inc_j_amigos:
				addi $t1, $t1, 1 #j++
				slt $t7, $t1, $s1 #t7 recebe 1 se j<length(vetor)
				bne $t7, $zero, loop_j_amigos #se t7 == 1 o vamos para a proxima iteracao do loop j.
				
			inc_i_amigos:
			addi $t0, $t0, 1 #i++
			subi $t7, $s1, 1 #t7 (ultimo indice do vetor) = length(vetor) - 1 
			slt $t8, $t0, $t7 #o loop continua se o proximo i for menor que o ultimo indice do vetor
			bne $t8, $zero, loop_i_amigos

				
		addi $v0, $s2, 0 #retornando o numero de numeros amigos dentro do vetor
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		jr $ra
		
		
	soma_dos_divisores: #(a0 = numero)
		addi $sp, $sp, -16
		sw $s0, 0($sp)
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		sw $t2, 12($sp)
		
		addi $s0, $zero, 0 #soma = 0
		addi $t0, $zero, 1 #i = i
		
		loop_divisores:
			div $a0, $t0 
			mfhi $t1 #t1 = resto da divisao do numero por i
			
			bne $t1, $zero, inc_i_divisores #if (t1 == 0) 
			add $s0, $s0, $t0 # soma += t0 (i)
			
		inc_i_divisores:
			addi $t0, $t0, 1
			slt $t2, $t0, $a0
			bne $t2, $zero, loop_divisores # se i<a0 o loop continua
		
		addi $v0, $s0, 0 #retornando a soma dos divisores de a0
		lw $s0, 0($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		addi $sp, $sp, 16
		jr $ra				
