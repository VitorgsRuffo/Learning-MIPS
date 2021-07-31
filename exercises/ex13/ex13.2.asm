#Avaliação 4 - exercicio 2
#Nome: Vitor Gabriel da Silva Ruffo 

.data
	msg2: .asciiz "\nLeitura do vetor:\n"
	msg3: .asciiz "vetor["
	msg4: .asciiz "] = "
	msg5: .asciiz "\n\nVetor x:\n"
	msg6: .asciiz "\n\nVetor y (primos de x):\n"
	msgErro: .asciiz "\n\nNao ha elementos primos no vetor.\n\n"
	
.text
	main: 
		#Alocando o vetor x:
		addi $a0, $zero, 20
		addi $a1, $zero, 4  #a1 = tamanho de um elemento = sizeof(int) = 4
		jal alocar_vetor    #(tamanhoVetor:int, tamanhoElemento:int):address
		la $s0, ($v0)       #s0 = endereço base do vetor x
		
		#Lendo o vetor x:
		addi $a0, $s0, 0
		addi $a1, $zero, 20
		la $a2, msg2
		jal ler_vetor_int   #(vetor:address, tamanhoVetor:int, mensagem:string):void
		
		#Imprimindo vetor x:
		addi $a0, $s0, 0
		addi $a1, $zero, 20
		la $a2, msg5
		jal imprimir_vetor #(vetor:address, tamanhoVetor:int, mensagem:string):void
		
		#Obtendo os elementos primos de x:
		addi $a0, $s0, 0
		addi $a1, $zero, 20
		jal elementos_primos_vetor #(vetor:address, tamanhoVetor:int):int*
		addi $s1, $v0, 0  #s1 = endereço base do vetor y
		addi $s2, $v1, 0  #s2 = tamanho vetor y
		
		beq $s2, $zero, else #if(tamanhoVetorY > 0) imprimirVetor(y)
		addi $a0, $s1, 0
		addi $a1, $s2, 0
		la $a2, msg6
		jal imprimir_vetor #(vetor:address, tamanhoVetor:int, mensagem:string):void
		b fim_if
		
		else:			   #else print("Nao ha elementos primos no vetor")
		addi $v0, $zero, 4
		la $a0, msgErro
		syscall
		fim_if:
		
		######Fim do programa######
		li $v0, 10
		syscall 


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
	
	
	e_primo: #((a0) numero:int):int 0 -> nao e primo, 1 -> e primo
		
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
		
		
	soma_dos_divisores: #((a0) numero:int):int
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
		
		
	elementos_primos_vetor: #(vetor:address, tamanhoVetor:int):int*
		addi $sp, $sp, -16
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $ra, 12($sp)
		
		addi $s0, $a1, 0      #s0 = tamanho do vetor
		la $s1, ($a0)         #s1 = endereço base do vetor
		addi $t0, $zero, 0    #j = 0 
		addi $t1, $zero, 0    #i = 0 
		
		#Alocando o vetor y:
		addi $a0, $s0, 0
		addi $a1, $zero, 4  #a1 = tamanho de um elemento = sizeof(int) = 4
		jal alocar_vetor    #(tamanhoVetor:int, tamanhoElemento:int):address
		la $s2, ($v0)       #s2 = endereço base do vetor y
		
		loop_primos_vetor:
			sll $t2, $t1, 2   #t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $s1 #t2 = deslocamento + endereço base do vetor (t2 == &vetorx[i])	
			lw $t3, 0($t2) 	#t3 = elemento atual do vetor = vetorx[i]
			
			addi $a0, $t3, 0 #passando o elemento atual do vetor como parametro
			jal e_primo
			addi $t4, $v0, 0 #se o elemento atual for primo: t4 == 1, se nao: t4 == 0
			
			beq $t4, $zero, inc_i_primos_vetor #if (e_primo(vetorx[i]) 
			sll $t2, $t0, 2 			     #    y[j] = vetorx[i]
			add $t2, $t2, $s2
			sw $t3, 0($t2)
			addi $t0, $t0, 1                   #    j++
			
			inc_i_primos_vetor:	
			addi $t1, $t1, 1 			  #i++
			bne $t1, $s0, loop_primos_vetor #while(i<tamanhoVetor)
   		
   		
		addi $v0, $s2, 0 #return y
		addi $v1, $t0, 0 #v1 = j = tamanho vetor y
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		jr $ra
