#Nome: Vitor G. S. Ruffo | #Atividade 17.1

.data
	msg1: .asciiz "\n\nLeitura de vetor x:\n"
	msg2: .asciiz "\n\nLeitura de vetor y:\n"
	msg3: .asciiz "\nTamanho dos vetores: "
	msg4: .asciiz "\nvet["
	msg5: .asciiz "] = "
	msg6: .asciiz "\n\nProduto escalar entre x e y = "
	
.text
	main: 
		addi $s0, $zero, 4  #s0 = tamanho dos elementos em bytes = 4 bytes = sizeof(int)
		
		la $a0, msg3
		jal ler_n
		addi $s1, $v0, 0   #s1 = tamanho do vetores
		
		#alocando e lendo o vetor x:
		addi $a0, $s1, 0
		addi $a1, $s0, 0
		jal alocar_vetor    #(tamanhoVetor:int, tamanhoElemento:int):address
		la $s2, ($v0)       #s2 = endereço base do vetor x
		
		addi $a0, $s2, 0
		addi $a1, $s1, 0
		la $a2, msg1
		jal ler_vetor_int   #(vetor:address, tamanhoVetor:int, mensagem:string):void
		
		#alocando e lendo o vetor y:
		addi $a0, $s1, 0
		addi $a1, $s0, 0
		jal alocar_vetor    #(tamanhoVetor:int, tamanhoElemento:int):address
		la $s3, ($v0)       #s3 = endereço base do vetor y
		
		addi $a0, $s3, 0
		addi $a1, $s1, 0
		la $a2, msg2
		jal ler_vetor_int   #(vetor:address, tamanhoVetor:int, mensagem:string):void

		la $a0, ($s2)
		la $a1, ($s3) 
		addi $a2, $s1, 0
		jal produto_escalar_vetores_int #(vetor1:address, vetor2:address, tamanhoVetores:int):int
		addi $s4, $v0, 0       		  #s4 = produto escalar entre x e y = x . y
		
		la $a0, msg6
		addi $a1, $s4, 0
		jal imprimir_string_seguida_de_inteiro
		
		
		###Fim do programa###
		li $v0, 10
		syscall 
	
	
	
	ler_n: #(mensagem:string):int
		
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
		
	
	ler_vetor_int: #(vetor:address, tamanhoVetor:int, mensagem:string):void
		addi $sp, $sp, -12 #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
					 	  
		add $s0, $a1, $zero   #guardar o tamanho do vetor em $s0
		la $s1, ($a0)         # endereço base do vetor
		add $s2, $zero, $zero # i = 0 
		
		addi $v0, $zero, 4
		la $a0, ($a2)
		syscall	# imprimir: Leitura de Vetor:
		
		leitura:
			sll $t0, $s2, 2 # t0 = 4 * i (i.e, deslocamento)
			add $t0, $t0, $s1 # t0 = deslocamento + endereço base do vetor (t0 == &vetor[i])
			
			addi $v0, $zero, 4
			la $a0, msg4
			syscall  #imprimir: vetor[
			
			addi $v0, $zero, 1
			add $a0, $zero, $s2
			syscall  #imprimir: i
			
			addi $v0, $zero, 4
			la $a0, msg5
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
		
		
	produto_escalar_vetores_int: #(vetor1:address, vetor2:address, tamanhoVetores:int):int	
		
		addi $sp, $sp, -12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		la $s0, ($a0) 	 #s0 = endereço base vetor 1
		la $s1, ($a1)	 #s1 = endereço base vetor 2
		addi $s2, $a2, 0   #s2 = tamanho vetores
		
		addi $t0, $zero, 0 #i = 0
		addi $v0, $zero, 0 #resultado = 0
		
		loop_produto:
			sll $t1, $t0, 2   # t1 = 4 * i (i.e, deslocamento)
			
			add $t2, $t1, $s0 # t2 = deslocamento + endereço base do vetor 1 (t2 == &vetor1[i])
			lw $t3, 0($t2)    # t3 = vetor1[i]
			
			add $t2, $t1, $s1 # t2 = deslocamento + endereço base do vetor 2 (t2 == &vetor2[i])
			lw $t4, 0($t2)    # t4 = vetor2[i]
			
			mult $t3, $t4     
			mflo $t5  		#t5 = vetor1[i] * vetor2[i]
			
			add $v0, $v0, $t5 #resultado += vetor1[i] * vetor2[i]
			
			addi $t0, $t0, 1  	   #i++
			blt $t0, $s2, loop_produto #if(i<tamanhoVetores) goto loop_produto
		
		
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