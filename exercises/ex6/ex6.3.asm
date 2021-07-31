#Nome: Vitor G. S. Ruffo | #Atividade 11.3

.data
	vetA: .space 60 #vetA = malloc(15 * sizeof(int))
	vetB: .space 28 #vetB = malloc(7 * sizeof(int))
	intersecao: .space 28 #intersecao = malloc(7 * sizeof(int))
	msg1: .asciiz "\nLeitura do vetor A:\n"
	msg2: .asciiz "\nLeitura do vetor B:\n"
	msg3: .asciiz "\nvetor["
	msg4: .asciiz "] = "
	msg5: .asciiz "\nVetor intersecao:\n"
.text
	main:
		##############Lendo o vetor A##################
		addi $s0, $zero, 15 # s0 = tamanho do vetorA
		la $a0, vetA 	  #parametro a0 = endereco base do vetor 
		add $a1, $s0, $zero #parametro a1 = tamanho do vetor
		la $a2, msg1	  #parametro a2 = mensagem
		jal ler_vetor
		
		
		##############Lendo o vetor B##################
		addi $s1, $zero, 7  # s1 = tamanho do vetorB
		la $a0, vetB 	  #parametro a0 = endereco base do vetor 
		add $a1, $s1, $zero #parametro a1 = tamanho do vetor 
		la $a2, msg2	  #parametro a2 = mensagem
		jal ler_vetor
		
			
		############Encontrando intersecao############
		la $a0, vetA 		#parametro a0 = endereco base do vetor A 
		la $a1, vetB		#parametro a1 = endereco base do vetor B 
		la $a2, intersecao	#parametro a2 = endereco base do vetor intersecao 
		jal encontrar_intersecao
		
		
		###########Imprimir vetor intersecao##########
		la $t0, intersecao # endereço base do vetor
		addi $t2, $zero, 0 # i = 0
		
		addi $v0, $zero, 4
		la $a0, msg5
		syscall  #Vetor intersecao:
		print_loop:
			sll $t3, $t2, 2 # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i])	
			
			lw $t1, 0($t3)
			
			la $a0, msg3 
			add $a1, $t2, $zero 
			jal imprimir_string_seguida_de_inteiro
			la $a0, msg4 
			add $a1, $t1, $zero 
			jal imprimir_string_seguida_de_inteiro
			
			addi $t2, $t2, 1 #i++
			bne $s1, $t2, print_loop #while(i<7)
		
		
		###########Finalizando o programa############
		addi $v0, $zero, 10
		syscall
		
		
		
		
	ler_vetor: #(a0 = endereco base, a1 = tamanho, a2 = mensagem)
		addi $sp, $sp, -12 #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		add $s0, $a1, $zero   #s0 = tamanho do vetor 
		la $s1, ($a0)         #s1 = endereço base do vetor
		add $s2, $zero, $zero #i(s2) = 0 
		
		addi $v0, $zero, 4
		la $a0, ($a2)
		syscall	# imprimir: Leitura do Vetor x:
		
		leitura:
			sll $t0, $s2, 2 # t0 = 4 * i (i.e, deslocamento)
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
		
	encontrar_intersecao: #(a0 = endereco base de A, a1 = endereco base de B, a2 = endereco base de intersecao)
		addi $sp, $sp, -28
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $s4, 16($sp)
		sw $s5, 20($sp)
		sw $ra, 24($sp)
		
		la $s0, ($a0)   #s0 = endereco base de A
		la $s1, ($a1)   #s1 = endereco base de B	
		la $s2, ($a2)   #s2 = endereco base de intersecao
		addi $s3, $zero, 0 #i = 0
		addi $s4, $zero, 0 #j = 0
		addi $s5, $zero, 0 #k = 0
		
		addi $t0, $zero, 15 #tamanho A
		addi $t1, $zero, 7  #tamanho B/intersecao
		
		loop_i:
			sll $t2, $s3, 2 # t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $s1 # t2 = deslocamento + endereço base do vetor B (t2 == &vetB[i])	
			lw $t3, 0($t2) #t3 = vetB[i]
			
			addi $s4, $zero, 0 #j = 0
			loop_j:
				sll $t2, $s4, 2 # t2 = 4 * j (i.e, deslocamento)
				add $t2, $t2, $s0 # t2 = deslocamento + endereço base do vetor A (t2 == &vetA[j])	
				lw $t4, 0($t2) #t4 = vetA[j]
			
				bne $t3, $t4, inc_j #if(t3 == t4)
				
				addi $a1, $t3, 0 #parametro a1 = B[i] 
				#o parametro intersecao ja esta em a2
				#o parametro k sera o mesmo estado do registrador s5 que o procedimento atual esta usando.
				jal salvar_elemento
				
				b inc_i #break
				
				inc_j:
				addi $s4, $s4, 1 #j++
				blt $s4, $t0, loop_j
		
			inc_i:
			addi $s3, $s3, 1 #i++
			blt $s3, $t1, loop_i
		
						
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $ra, 24($sp)
		addi $sp, $sp, 28
		jr $ra
		
		
	salvar_elemento:#(a1 = B[i], a2 = endereco base de intersecao, k = s5)
		addi $sp, $sp, -12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		addi $s0, $zero, 0 #z = 0
		
		loop_salvar:
			sll $s1, $s0, 2   # s1 = 4 * z (i.e, deslocamento)
			add $s1, $s1, $a2 # s1 = deslocamento + endereço base do vetor intersecao (s1 == &intersecao[z])	
			lw $s2, 0($s1) #s2 = intersecao[z]
			
			beq $s2, $a1, fim_salvar #if(intersecao[z] == B[i]) return; //o elemento nao e salvo se ele ja estiver no vetor intersecao
      		
      		addi $s0, $s0, 1 #z++
      		blt $s0, $s5, loop_salvar # while(z<tamanho atual do vetor intersecao (i.e, proxima posicao livre no vetor intersecao))		
		
		salvar:
		sll $s1, $s5, 2   # s1 = 4 * s5 (i.e, deslocamento)
		add $s1, $s1, $a2 # s1 = deslocamento + endereço base do vetor intersecao (s1 == &intersecao[k])	
		sw $a1, 0($s1) 	#intersecao[k] = B[i]
		addi $s5, $s5, 1  #k++
			
		fim_salvar:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12
		jr $ra
		
		
	imprimir_string_seguida_de_inteiro: #(a0 = string, a1 = inteiro )

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 
		jr $ra #retornando o controle para o chamador		
		
