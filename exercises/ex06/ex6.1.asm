#Nome: Vitor G. S. Ruffo | #Atividade 11.1

.data
	vetx:	.space 60 #vet = malloc(15 * sizeof(int))
	primosx: .space 60
	msg1: .asciiz "Leitura do Vetor:\n"
	msg2: .asciiz "\nvetor["
	msg3: .asciiz "] = "
	msg4: .asciiz "\nElementos do vetor com os primos de x:\n"
	

.text
	main:
		##############Lendo um vetor de 15 posicoes##################
		addi $s0, $zero, 15 # s0 = tamanho do vetor
		add $a1, $s0, $zero #passando o tamanho do vetor como parametro
		jal ler_vetor


		###############Encontrando os primos do vetor################
		add $a1, $s0, $zero #passando o tamanho do vetor como parametro
		jal encontrar_primos
		
		
		#############Imprimir vetor dos primos#######################
		la $t0, primosx # endereço base do vetor
		addi $t2, $zero, 0 # i = 0
		
		addi $v0, $zero, 4
		la $a0, msg4
		syscall  #Elementos do vetor:
		print_loop:
			sll $t3, $t2, 2 # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i])	
			
			lw $t1, 0($t3)
			
			la $a0, msg2 
			add $a1, $t2, $zero 
			jal imprimir_string_seguida_de_inteiro
			la $a0, msg3 
			add $a1, $t1, $zero 
			jal imprimir_string_seguida_de_inteiro
			
			addi $t2, $t2, 1 #i++
			bne $s0, $t2, print_loop #while(i<15)
		
		
		###########Finalizando o programa############
		addi $v0, $zero, 10
		syscall
		


	ler_vetor: #(a1 = tamanho do vetor)
		addi $sp, $sp, -12 #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		addi $v0, $zero, 4
		la $a0, msg1
		syscall	# imprimir: Leitura do Vetor:
				 	      
		
		add $s0, $a1, $zero #guardar o tamanho do vetor em $s0
		
		la $s1, vetx # endereço base do vetor
		add $s2, $zero, $zero # i = 0 
		
		leitura:
			sll $t0, $s2, 2 # t0 = 4 * i (i.e, deslocamento)
			add $t0, $t0, $s1 # t0 = deslocamento + endereço base do vetor (t0 == &vetor[i])
			
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
		
		lw $s0, 0($sp)  #guardando os valores originais de volta em s0/s1/s2
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12 #desempilhando s0/s1/s2  
		jr $ra #retornando o controle para o chamador
		
		
	encontrar_primos: #(a1 = tamanho do vetor)
		
		addi $sp, $sp, -16 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		sw $s1, 4($sp) #
		sw $s2, 8($sp) #
		sw $ra, 12($sp)#se vamos chamar um procedimento dentro de outro precisamos salvar o endereço de retorno do chamador, pois, na hora do "jal X" o valor de $ra sera alterado.
		
		la $s0, vetx  	 #s0 = endereço base do vetorx
		addi $s1, $zero, 0 #s1 = indice atual do vetorx (i)
		la $s2, ($a1) 	 #s2 = tamanho do vetorx
		
		la $t0, primosx  	 #t0 = endereço base do primosx
		addi $t1, $zero, 0 #t1 = indice atual do primosx (j)
		
		loop_encontrar_primos:
			sll $t2, $s1, 2 # t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $s0 # t2 = deslocamento + endereço base do vetor (t2 == &vetorx[i])	
			
			lw $t3, 0($t2) #t3 = elemento atual do vetor
			
			#Checar se o elemento atual e primo.
			
			addi $a0, $t3, 0 #passando o elemento atual do vetor como parametro
			jal o_numero_e_primo
			addi $t4, $v0, 0 #se o elemento atual for primo t4 == 1, se nao t4 == 0
			
			# Se sim, vamos adiciona-lo ao vetor primosx. Se nao, jump para inc_i
			beq $t4, $zero, inc_i
			
			sll $t2, $t1, 2 # t2 = 4 * j (i.e, deslocamento)
			add $t2, $t2, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &primosx[j])	
			sw $t3, 0($t2) #primosx[j] = elemento atual do vetor
			addi $t1, $t1, 1 #j++
			
		inc_i:	
			addi $s1, $s1, 1 #i++
			bne $s1, $s2, loop_encontrar_primos #if (i < tamanho do vetorx) continuar loop.
	
		lw $s0, 0($sp) 
		lw $s1, 4($sp) 
		lw $s2, 8($sp) 
		lw $ra, 12($sp) 
		addi $sp, $sp, 16
		jr $ra
		
	
	o_numero_e_primo: #(a0 = numero): 0 -> nao e primo, 1 -> e primo
		
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
		
		
	imprimir_string_seguida_de_inteiro: #(a0 = string, a1 = inteiro )

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 
		jr $ra #retornando o controle para o chamador			
