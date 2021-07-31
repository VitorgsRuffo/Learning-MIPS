#Nome: Vitor G. S. Ruffo | #Atividade 11.2

.data
	veta:	.space 40 #veta = malloc(10 * sizeof(int))
	vetb:	.space 40 #vetb = malloc(10 * sizeof(int))
	msg1: .asciiz "Leitura do Vetor:\n"
	msg2: .asciiz "\nvetor["
	msg3: .asciiz "] = "
	msg4: .asciiz "\nSoma dos elementos do vetor A cujo indice é par: "
	msg5: .asciiz "\nSoma dos elementos do vetor B cujo indice é impar: "
	
.text
	main:
		addi $s0, $zero, 10 # s0 = tamanho dos vetores a e b
		
		
		##############Lendo o vetor a:##################
		la $a0, veta #passando o endereço base do vetor como parametro
		add $a1, $s0, $zero #passando o tamanho do vetor como parametro
		jal ler_vetor
		
		
		##############Lendo o vetor b:##################
		la $a0, vetb #passando o endereço base do vetor como parametro
		add $a1, $s0, $zero #passando o tamanho do vetor como parametro
		jal ler_vetor
		
		
		###########somatoria posicoes pares e impares:############		
		la $a0, veta #passando o endereço base do vetor a como parametro
		la $a1, vetb #passando o endereço base do vetor b como parametro
		add $a2, $s0, $zero #passando o tamanho dos vetores como parametro
		jal soma_posicoes_pares_e_impares
		addi $s1, $v0, 0 #recebendo o retorno do procedimento
		addi $s2, $v1, 0 #
		
		la $a0, msg4
		addi $a1, $s1, 0
		jal imprimir_string_seguida_de_inteiro
		
		la $a0, msg5
		addi $a1, $s2, 0
		jal imprimir_string_seguida_de_inteiro
		
		
		###########Finalizando o programa############
		addi $v0, $zero, 10
		syscall
		
		
		
		
	soma_posicoes_pares_e_impares: #(a0 = veta, a1 = vetb, a2 = tamanho de a/b)
	
		addi $sp, $sp, -24
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		sw $s1, 4($sp) #
		sw $s2, 8($sp) #
		sw $s3, 12($sp)#
		sw $s4, 16($sp)#
		sw $s5, 20($sp)#
			
		la $s0, ($a0) 		#s0 = endereco base vetor a
		la $s1, ($a1) 	 	#s1 = endereco base vetor b
		addi $s2, $zero, 0 	#i = 0 
		addi $s3, $a2, 0   	#s3 = tamanho de a/b
		
		addi $s4, $zero, 0 	#somaparA = 0
		addi $s5, $zero, 0 	#somaimparB = 0
		addi $t7, $zero, 2	#t7 = constante 2

		loop_soma:
			sll $t0, $s2, 2 # t0 = 4 * i (i.e, deslocamento)
			
			#testar se o i (posicao atual) e par ou impar:
			div $s2, $t7 #i / 2
			mfhi $t6 	 #t6 = resto da divisao
			bne $t6, $zero, posicao_impar #if(resto da divisao == 0)
			
			posicao_par:
				add $t1, $t0, $s0 # t1 = deslocamento + endereço base do vetor A (t1 == &vetorA[i])	
				lw $t2, 0($t1) #t2 = elemento atual do vetorA[i]
				add $s4, $s4, $t2
				b inc_i
				
			posicao_impar:
				add $t1, $t0, $s1 # t1 = deslocamento + endereço base do vetor B (t1 == &vetorB[i])	
				lw $t2, 0($t1) #t2 = elemento atual do vetorB[i]
				add $s5, $s5, $t2
			
			inc_i:
				addi $s2, $s2, 1 #i++
				bne $s2, $s3, loop_soma #if (i < tamanho do vetor a/b) continuar loop.
		
		
		addi $v0, $s4, 0 #retornando a soma das posicoes pares do vetor a.
		addi $v1, $s5, 0 #retornando a soma das posicoes impares do vetor b.
		lw $s0, 0($sp) 
		lw $s1, 4($sp) 
		lw $s2, 8($sp) 
		lw $s3, 12($sp) 
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		addi $sp, $sp, 24
		jr $ra
		
		
	ler_vetor: #(a0 = endereco base do vetor, a1 = tamanho do vetor)
		addi $sp, $sp, -12 #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
					 	  
		add $s0, $a1, $zero #guardar o tamanho do vetor em $s0
		la $s1, ($a0) # endereço base do vetor
		add $s2, $zero, $zero # i = 0 
		
		addi $v0, $zero, 4
		la $a0, msg1
		syscall	# imprimir: Leitura do Vetor:
		
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
		
		
	imprimir_string_seguida_de_inteiro: #(a0 = string, a1 = inteiro )

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 
		jr $ra #retornando o controle para o chamador	
		