#Avaliação 4 - exercicio 1
#Nome: Vitor Gabriel da Silva Ruffo 

.data
	msg1: .asciiz "\nTamanho do vetor: "
	msg2: .asciiz "\nLeitura do vetor:\n"
	msg3: .asciiz "vetor["
	msg4: .asciiz "] = "
	msg5: .asciiz "\nVetor:\n"
	msg_maior: .asciiz "\n\nQuantidade de elementos maiores que a soma do vetor: "
	msg_impar: .asciiz "\n\nQuantidade de numeros impares: "
	msg_produto1: .asciiz "\n\nProduto do maior elemento par com o menor elemento ímpar: "
	msg_produto2: .asciiz "\n\nNao ha elementos pares ou impares no vetor.\n"
	msg_ord: .asciiz "\n\nVetor apos a ordenacao:\n"

.text
	main: 
		#Lendo o tamanho do vetor:
		la $a0, msg1
		jal ler_n
		addi $s0, $v0, 0   #s0 = tamanho do vetor
		
		#Alocando o vetor:
		addi $a0, $s0, 0
		addi $a1, $zero, 4  #a1 = tamanho de um elemento = sizeof(int) = 4
		jal alocar_vetor    #(tamanhoVetor:int, tamanhoElemento:int):address
		la $s1, ($v0)       #s1 = endereço base do vetor
		
		#Lendo o vetor:
		addi $a0, $s1, 0
		addi $a1, $s0, 0
		la $a2, msg2
		jal ler_vetor_int   #(vetor:address, tamanhoVetor:int, mensagem:string):void
		
		#Imprimindo vetor:
		la $a0, ($s1)
		addi $a1, $s0, 0
		la $a2, msg5
		jal imprimir_vetor #(vetor:address, tamanhoVetor:int, mensagem:string):void
		
		
		#a) Calculando o numero de elementos do vetor maiores que a soma de todos os elementos do vetor:
		la $a0, ($s1)
		addi $a1, $s0, 0
		jal proc_maior_soma #(vetor:address, tamanhoVetor:int):int
		
		#imprimindo resultado:
		la $a0, msg_maior
		addi $a1, $v0, 0
		jal imprimir_string_seguida_de_inteiro #(mensagem:string, numero:int):void
		
		
		#b) Calculando o numero de elementos impares do vetor:
		la $a0, ($s1)
		addi $a1, $s0, 0
		jal proc_num_impar #(vetor:address, tamanhoVetor:int):int
		
		#imprimindo resultado:
		la $a0, msg_impar
		addi $a1, $v0, 0
		jal imprimir_string_seguida_de_inteiro #(mensagem:string, numero:int):void
		
		
		#c) Calculando o produto do maior elemento par do vetor com o menor elemento ímpar do vetor:
		la $a0, ($s1)
		addi $a1, $s0, 0
		jal proc_prod_pos #(vetor:address, tamanhoVetor:int):int*
		#retorno: v0 (produto), v1 (=1 se deu certo, =0 se deu errado)
		
		addi $t2, $zero, 1   	   #t2 = constante 1   
		
		blt $v1, $t2, else_prod    #if(v1==1) tudo deu certo.
		#imprimindo resultado 1:
		la $a0, msg_produto1
		addi $a1, $v0, 0          
		jal imprimir_string_seguida_de_inteiro #(mensagem:string, numero:int):void
		b fim_prod
		
		else_prod:		   	   #else nao havia elementos pares ou impares.
		#imprimindo resultado 2:
		addi $v0, $zero, 4
		la $a0, msg_produto2
		syscall
		fim_prod:
		
		
		#d) Ordenando o vetor:
		la $a0, ($s1)
		addi $a1, $s0, 0
		jal proc_ord #(vetor:address, tamanhoVetor:int):void
		
		#imprimindo vetor ordenado:
		la $a0, ($s1)
		addi $a1, $s0, 0
		la $a2, msg_ord
		jal imprimir_vetor #(vetor:address, tamanhoVetor:int, mensagem:string):void
		
		
		######Fim do programa######
		li $v0, 10
		syscall 
		
		
		
		
	ler_n: #(mensagem:string):int
		
		addi $v0, $zero, 4
		syscall		 #"exemplo: Insira um valor para N:"
		
		addi $v0, $zero, 5 #v0 = codigo de leitura de inteiro 
		syscall		 #v0 = inteiro lido
		
		jr $ra 		 #retornando o controle para o chamador


	alocar_vetor:#(tamanhoVetor:int, tamanhoElemento:int):address
		
		mult $a0, $a1 
		mflo $a0 	  	 #a0 = tamanhoVetor * tamanhoElemento = total de bytes do vetor
		
		addi $v0, $zero, 9 #v0 = codigo de alocacao dinamica de memoria
		syscall 		 #aloca a0 bytes e guarda o endereço do inicio do bloco em v0.
		
		jr $ra 		 #retornando o controle para o chamador	
		
	
	ler_vetor_int: #(vetor:address, tamanhoVetor:int, mensagem:string):void
		addi $sp, $sp, -12    #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
					 	  
		addi $s0, $a1, 0      #s0 = tamanho do vetor 
		la $s1, ($a0)         #s1 = endereço base do vetor
		addi $s2, $zero, 0    #i = 0 
		
		addi $v0, $zero, 4    #v0 = codigo de impressao de string
		la $a0, ($a2)         #a0 = endereço da mensagem
		syscall		    #exemplo: Leitura de Vetor:
		
		leitura:
			sll $t0, $s2, 2   #t0 = 4 * i (i.e, deslocamento)
			add $t0, $t0, $s1 #t0 = deslocamento + endereço base do vetor (t0 == &vetor[i])
			
			addi $v0, $zero, 4
			la $a0, msg3
			syscall   #imprimir: vetor[
			
			addi $v0, $zero, 1
			add $a0, $zero, $s2
			syscall   #imprimir: i
			
			addi $v0, $zero, 4
			la $a0, msg4
			syscall   #imprimir: ] = 
			
			addi $v0, $zero, 5 
			syscall	   #v0 = inteiro lido
			sw $v0, 0($t0) #vetor[i] = v0
			
			addi $s2, $s2, 1 	    # i++
			bne $s2, $s0, leitura # while(i < numero de elementos do vetor)
		
		lw $s0, 0($sp)    #guardando os valores originais de volta em s0/s1/s2
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12 #desempilhando s0/s1/s2  
		jr $ra 		#retornando o controle para o chamador
		
		
	imprimir_string_seguida_de_inteiro: #(mensagem:string, numero:int):void

		addi $v0, $zero, 4 
		syscall		#imprime a string	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 		#imprime o inteiro
		jr $ra 	   	#retornando o controle para o chamador


	imprimir_vetor:#(vetor:address, tamanhoVetor:int, mensagem:string):void
	
		addi $sp, $sp, -28 #armazenando valores de s0/t0-t4/ra na pilha
		sw $s0, 0($sp)
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		sw $t2, 12($sp)
		sw $t3, 16($sp)
		sw $t4, 20($sp)
		sw $ra, 24($sp)
						
		la $t0, ($a0) 	 #t0 = endereço base do vetor
		addi $s0, $a1, 0   #s0 = tamanho do vetor
		addi $t2, $zero, 0 #i = 0
		
		addi $v0, $zero, 4
		la $a0, ($a2)
		syscall  #exemplo de mensagem: Vetor:
		
		addi $v0, $zero, 11 #v0 = codigo de impressao de char
		addi $a0, $zero, 91 #a0 = caracter a ser impresso = 91 (codigo ASCII do caractere '[') 
		syscall  		  #[ 
		
		print_loop:
			sll $t3, $t2, 2     #t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0   #t3 = deslocamento + endereço base do vetor (t3 == &vetor[i])	
			
			lw $t4, 0($t3)	  #t4 = vetor[i]
			
			addi $v0, $zero, 11 #v0 = codigo de impressao de char
			addi $a0, $zero, 32 #a0 = caracter a ser impresso = 32 (codigo ASCII do caractere ' ') 
			syscall  		  # 
			
			addi $v0, $zero, 1  #v0 = codigo de impressao de inteiro
			addi $a0, $t4, 0    #a0 = vetor[i]
			syscall  		  #
			
			addi $t2, $t2, 1 		 #i++
			bne $s0, $t2, print_loop #while(i<tamanhoVetor)
		
		
		addi $v0, $zero, 11 #v0 = codigo de impressao de char
		addi $a0, $zero, 32 #a0 = caracter a ser impresso = 32 (codigo ASCII do caractere ' ') 
		syscall 		  #
		
		addi $v0, $zero, 11 #v0 = codigo de impressao de char
		addi $a0, $zero, 93 #a0 = caracter a ser impresso = 93 (codigo ASCII do caractere ']') 
		syscall  		  #]
			
		lw $s0, 0($sp) #guardando os valores originais de volta em s0/t0-t3/ra
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		lw $t4, 20($sp)
		lw $ra, 24($sp)
		addi $sp, $sp, 28 #desempilhando s0/t0-t3/ra 
		jr $ra 		#retornando o controle para o chamador
	
	
	soma_elementos_vetor: #((a0) vetor:address, (a1) tamanhoVetor:int):int
	
		addi $sp, $sp, -20 
		sw $s0, 0($sp) 
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		sw $t2, 12($sp)
		sw $t3, 16($sp)
		
		la $t0, ($a0) 	 #t0 = endereço base do vetor
		addi $t1, $zero, 0 #i = 0
		addi $s0, $zero, 0 #soma = 0
		
		loop_soma:
			sll $t2, $t1, 2   #t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $t0 #t2 = deslocamento + endereço base do vetor (t2 == &vetor[i])	
			
			lw $t3, 0($t2) 	#t3 = elemento atual do vetor = vetor[i]
			
			add $s0, $s0, $t3 #soma_elementos += elemento_atual
			
			addi $t1, $t1, 1 		#i++
			bne $t1, $a1, loop_soma #while(i<tamanhoVetor)
	
		add $v0, $s0, $zero #armazenando o valor de retorno (soma) em $v0
		lw $s0, 0($sp)  	  #guardando os valores originais de volta em s0/t0-t3
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		addi $sp, $sp, 20
		jr $ra 		  #retornando o controle para o chamador	
					
					
	proc_maior_soma: #(vetor:address, tamanhoVetor:int):int
	 	
		addi $sp, $sp, -16    #armazenando valores de s0/s1/s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $ra, 12($sp)
	 
	 	addi $s0, $a1, 0      #s0 = tamanho do vetor 
		la $s1, ($a0)         #s1 = endereço base do vetor
		addi $s2, $zero, 0    #quantidade_maiores = 0 
		addi $t0, $zero, 0    #i = 0
		
		jal soma_elementos_vetor #((a0) vetor:address, (a1) tamanhoVetor:int):int
	 	addi $t1, $v0, 0         #t1 = soma dos elementos do vetor
	 	
	 	loop_maior_soma:
	 		sll $t2, $t0, 2   #t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $s1 #t2 = deslocamento + endereço base do vetor (t2 == &vetor[i])	
			lw $t3, 0($t2) 	#t3 = elemento atual do vetor = vetor[i]
			
			ble $t3, $t1, inc_i_maior_soma #if(vetor[i] > somaElementos)
			addi $s2, $s2, 1               #    quantidade_maiores++ 
			
			inc_i_maior_soma:
			addi $t0, $t0, 1 			#i++
			bne $t0, $a1, loop_maior_soma #while(i<tamanhoVetor)
	 	
	 	addi $v0, $s2, 0  #return quantidade_maiores
	 	lw $s0, 0($sp)    #guardando os valores originais de volta em s0/s1/s2/ra
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16 #desempilhando s0/s1/s2/ra  
		jr $ra 		#retornando o controle para o chamador
	
	
	e_impar: #((a0) numero:int):int -> retorna 1 se o numero for impar, se nao retorna 0
		addi $sp, $sp, -4
		sw $t2, 0($sp)
		
		addi $t2, $zero, 2 #contante 2
		
		div $a0, $t2      #numero / 2
		mfhi $t2          #t2 == resto da divisao
		
		addi $v0, $zero, 0
		
		beq $t2, $zero, fim_impar # if (resto == 0) return 0 else return 1
		addi $v0, $v0, 1 
		
		fim_impar:
		lw $t2, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
			
	proc_num_impar: #(vetor:address, tamanhoVetor:int):int
		
		addi $sp, $sp, -12
		sw $s0, 0($sp)  	 #armazenando valores de s0/s1/ra na pilha
		sw $s1, 4($sp) 
		sw $ra, 8($sp) 
		
		la $t0, ($a0)      #t0 = endereço base do vetor
		addi $s1, $a1, 0   #s1 = tamanho do vetor
		addi $t1, $zero, 0 #i = 0
		
		addi $s0, $zero, 0 #numero_de_elementos_impares = 0
		
		loop_num_impar:
			sll $t2, $t1, 2   #t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $t0 #t2 = deslocamento + endereço base do vetor (t2 == &vetor[i])	
			lw $t3, 0($t2)    #t3 = elemento atual do vetor = vetor[i]
			
			#checar se o elemento atual e impar. Se sim, incrementar o contador s0. Se nao, jump para inc_i
			
			addi $a0, $t3, 0 #passando o elemento atual do vetor como parametro
			jal e_impar
			addi $t4, $v0, 0 #se o elemento atual for impar: t4 == 1, se nao: t4 == 0
			
			beq $t4, $zero, inc_i_num_impar # se t4 != 0 incrementamos o contador:
			addi $s0, $s0, 1 			  # numero_de_elementos_impar++
			
			inc_i_num_impar:	
			addi $t1, $t1, 1 #i++
			bne $t1, $s1, loop_num_impar #if (i < tamanho do vetor) continuar loop.
	
		add $v0, $s0, $zero #armazenando o valor de retorno (numero de elementos impares) em $v0
		lw $s0, 0($sp)      #guardando os valores originais de volta em s0/s1/ra
		lw $s1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12   #desempilhando s0/s1/ra  
		jr $ra 		  #retornando o controle para o chamador	
		
	
	proc_prod_pos: #(vetor:address, tamanhoVetor:int):int* -> v0 (produto), v1(1 se deu certo, 0 se deu errado)
		
		addi $sp, $sp, -20    #armazenando valores de s0-3/ra na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $ra, 16($sp)
		
		addi $s0, $a1, 0          #s0 = tamanho do vetor 
		la $s1, ($a0)         	  #s1 = endereço base do vetor
		addi $t0, $zero, 0    	  #i = 0
		addi $s2, $zero, -999998     #maiorPar   = -999998
		addi $s3, $zero,  999999     #menorImpar =  999999

		loop_prod_pos:
			sll $t1, $t0, 2   #t1 = 4 * i (i.e, deslocamento)
			add $t1, $t1, $s1 #t1 = deslocamento + endereço base do vetor (t1 == &vetor[i])	
			lw $t2, 0($t1)    #t2 = elemento atual do vetor = vetor[i]
			
			addi $a0, $t2, 0 #passando o elemento atual do vetor como parametro
			jal e_impar
			addi $t3, $v0, 0 #se o elemento atual for impar: t3 == 1, se nao: t3 == 0
			
			
			beq $t3, $zero, else_prod_pos #if(e_impar(vetor[i]))
			
			bge $t2, $s3, inc_i_prod_pos  #   if(vetor[i] < menorImpar)
			addi $s3, $t2, 0              #     menorImpar = vetor[i]
			
			b inc_i_prod_pos
			else_prod_pos:		 	#else
			
			ble $t2, $s2, inc_i_prod_pos  #   if(vetor[i] > maiorPar)
			addi $s2, $t2, 0  		#    maiorPar = vetor[i]
			
			
			inc_i_prod_pos:	
			addi $t0, $t0, 1 		    #i++
			bne $t0, $s0, loop_prod_pos #if(i < tamanhoVetor) continuar loop.
			
		mult $s2, $s3
		mflo $v0          #v0 = maiorPar * menorImpar
		
		addi $s2, $s2, 999998   #se nao existe valores pares,   entao  s2 == 0
		addi $s3, $s3, -999999  #se nao existe valores impares, entao  s3 == 0 
		
		addi $v1, $zero, 0 
		
		beq $s2, $zero, fim_prod_pos 
		beq $s3, $zero, fim_prod_pos
		addi $v1, $v1, 1
		#Se existirem valores pares e impares no vetor entao v1 = 1
		#Senao v1 = 0
		
		fim_prod_pos:
		lw $s0, 0($sp)    #guardando os valores originais de volta em s0-3/ra  
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20 #desempilhando s0-3/ra  
		jr $ra 		#retornando o controle para o chamador				
																																													
																										
	proc_ord: #((a0) vetor:address, (a1) tamanhoVetor:int):void (algoritmo usado: gnome sort)
	
		addi $sp, $sp, -8
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		
		la $t0, ($a0) 	  #t0 = endereço base
		addi $t1, $a1, 0    #t1 = tamanho do vetor
		addi $v0, $zero, 0, #i = 0
		
		sll $t1, $t1, 2     #t1 *= 4 -> t1 vai passar a guardar a quantidade de bytes necessarios para guardar tamanhoVetor elementos. e.g, tamanhoVetor == 16 elementos, ..., t1 = 16 * 4 bytes = 64 bytes
  		
  		loop_ord:
   	 		slt $t3, $v0, $t1          	 
			beq $t3, $zero, fim_ord      #while (i < tamanhoVetor)
			bne $v0, $zero, comparar_ord #if(i == 0)
			addiu $v0, $v0, 4          	 #  i = i + 1
  		
  			comparar_ord:
    			addu $t2, $t0, $v0       # $t2 = endereço base + deslocamento em bytes (&vetor[i])
    			lw $t4, -4($t2)          # $t4 = vetor[i-1]
    			lw $t5, 0($t2)           # $t5 = vetor[i]
    			blt $t5, $t4, swap_ord   # if (arr[i] < arr[i-1]) swap(arr[i], arr[i-1])
    			addiu $v0, $v0, 4        # else i = i + 1; continue;
    			j loop_ord
  		
  			swap_ord:
    			sw $t4, 0($t2)          # swap (arr[i], arr[i-1])
    			sw $t5, -4($t2)
    			addiu $v0, $v0, -4      # i = i - 1
    			j loop_ord
  		
  		fim_ord:
   		lw $t0, 0($sp)
   		lw $t1, 4($sp)           
  	 	addi $sp, $sp, 8           
   		jr $ra
   		
		
