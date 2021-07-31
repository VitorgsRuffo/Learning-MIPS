#Nome: Vitor G. S. Ruffo

#Sugestoes de melhoria para o codigo:
	#Criar um procedimento para a impressao dos elementos do vetor.
	#Passar endereço base e tamanho do vetor para todas as funçoes (para torna-las genericas).

.data
	vet:
	msg1: .asciiz "Leitura de Vetor:\nInsira o numero de elementos:\n"
	msg2: .asciiz "\nvetor["
	msg3: .asciiz "] = "
	
	msg4: .asciiz "\n\nMaior elemento do vetor: "
	
	msg5: .asciiz "\nMenor elemento do vetor: "
	
	msg6: .asciiz "\nNumero de elementos pares do vetor: "

	msg7: .asciiz "\nMaior elemento par do vetor: "
	
	msg8: .asciiz "\nMenor elemento impar do vetor: "
	
	msg9: .asciiz "\nSoma dos elementos impares do vetor: "
	
	msg10: .asciiz "\nProduto dos elementos pares do vetor: "
	
	msg11: .asciiz "\nElementos do vetor:\n"
	
.text
	main:
		
		##############Lendo o vetor##################
		jal ler_vetor
		addi $s0, $v0, 0 #recebendo o numero de elementos lidos
		
		#############imprimindo vetor################
		la $t0, vet # endereço base do vetor
		addi $t2, $zero, 0 # i = 0
		
		addi $v0, $zero, 4
		la $a0, msg11
		syscall  #Elementos do vetor:
		print_loop:
			sll $t3, $t2, 2 # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i)	
			
			lw $t1, 0($t3)
			
			la $a1, msg2 
			add $a2, $t2, $zero 
			jal imprimir_string_seguida_de_inteiro
			la $a1, msg3 
			add $a2, $t1, $zero 
			jal imprimir_string_seguida_de_inteiro
			
			addi $t2, $t2, 1 #i++
			bne $s0, $t2, print_loop
		
		#############Maior elemento do vetor##########
		
		add $a0, $s0, $zero #passando o numero de elementos do vetor como parametro
		jal maior_elemento_vetor
		addi $s1, $v0, 0 #recebendo o maior elemento do vetor.
		
		la $a1, msg4 #passando a string a ser printada como parametro
		add $a2, $s1, $zero #passando o inteiro a ser printado como parametro
		jal imprimir_string_seguida_de_inteiro
		
		
		#############Menor elemento do vetor#########
		
		add $a0, $s0, $zero #passando o numero de elementos do vetor como parametro
		jal menor_elemento_vetor
		addi $s2, $v0, 0 #recebendo o menor elemento do vetor.
		
		la $a1, msg5 #passando a string a ser printada como parametro
		add $a2, $s2, $zero #passando o inteiro a ser printado como parametro
		jal imprimir_string_seguida_de_inteiro
		 
		
		##########Numero de elementos pares###########
		
		add $a0, $s0, $zero  #passando o numero de elementos do vetor como parametro
		jal numero_elementos_pares_vetor
		addi $s3, $v0, 0  #recebendo o numero de elementos pares do vetor.
		
		la $a1, msg6 #passando a string a ser printada como parametro
		add $a2, $s3, $zero #passando o inteiro a ser printado como parametro
		jal imprimir_string_seguida_de_inteiro
		
		
		############Maior elemento par#################
		
		add $a0, $s0, $zero  #passando o numero de elementos do vetor como parametro
		jal maior_elemento_par_vetor
		addi $s4, $v0, 0  #recebendo o maior elemento par do vetor.
		
		la $a1, msg7 #passando a string a ser printada como parametro
		add $a2, $s4, $zero #passando o inteiro a ser printado como parametro
		jal imprimir_string_seguida_de_inteiro
		
		
		############Menor elemento impar#################
		
		add $a0, $s0, $zero  #passando o numero de elementos do vetor como parametro
		jal menor_elemento_impar_vetor
		addi $s5, $v0, 0  #recebendo o menor elemento impar do vetor.
		
		la $a1, msg8 #passando a string a ser printada como parametro
		add $a2, $s5, $zero #passando o inteiro a ser printado como parametro
		jal imprimir_string_seguida_de_inteiro

		
		###########Soma dos elementos impares############
		
		add $a0, $s0, $zero  #passando o numero de elementos do vetor como parametro
		jal soma_elementos_impares_vetor
		addi $s6, $v0, 0  #recebendo a soma.
		
		la $a1, msg9 #passando a string a ser printada como parametro
		add $a2, $s6, $zero #passando o inteiro a ser printado como parametro
		jal imprimir_string_seguida_de_inteiro
		
		
		###########Produto dos elementos pares############
		
		add $a0, $s0, $zero  #passando o numero de elementos do vetor como parametro
		jal produto_elementos_pares_vetor
		addi $s7, $v0, 0  #recebendo o produto.
		
		la $a1, msg10 #passando a string a ser printada como parametro
		add $a2, $s7, $zero #passando o inteiro a ser printado como parametro
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
	
	
	imprimir_string_seguida_de_inteiro:
		#$a1 == string, $a2 == inteiro
		addi $v0, $zero, 4 
		la $a0, ($a1) 
		syscall	
		addi $v0, $zero, 1
		add $a0, $a2, $zero
		syscall 
		jr $ra #retornando o controle para o chamador
	
	
	maior_elemento_vetor:
		
		addi $sp, $sp, -4 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		
		la $t0, vet # endereço base do vetor
		lw $t1, 0($t0) #elemento atual do vetor
		
		addi $t2, $zero, 1 # i = 1 
		add $s0, $t1, $zero #maior elemento do vetor
		
		beq $a0, $t2, fim #se vetor possuir somente um elemento ele sera o maior
		
		loop:
			sll $t3, $t2, 2 # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i)	
			
			lw $t1, 0($t3)
			slt $t4, $s0, $t1  #t4 recebe 1 se s0 (maior elemento) < t1 (elemento atual) , se nao recebe 0.
			beq $t4, $zero, inc_i #se t4 for 0 significa que o elemento atual nao e maior que o maior elemento ate agora portanto o valor de s0 nao muda e seguimos para o proximo loop. Se nao :
			addi $s0, $t1, 0 #o maior elemento passa a ser o elemento atual
			
		inc_i:	addi $t2, $t2, 1 #i++
			bne $a0, $t2, loop
			
	fim:	add $v0, $s0, $zero #armazenando o valor de retorno (maior elemento) em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador
		
		
	menor_elemento_vetor:
		
		addi $sp, $sp, -4 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		
		la $t0, vet # endereço base do vetor
		lw $t1, 0($t0) #elemento atual do vetor
		
		addi $t2, $zero, 1 # i = 1 
		add $s0, $t1, $zero #menor elemento do vetor
		
		beq $a0, $t2, fim_2 #se vetor possuir somente um elemento ele sera o menor
		
		loop_2:
			sll $t3, $t2, 2 # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i)	
			
			lw $t1, 0($t3)
			slt $t4, $t1, $s0  #t4 recebe 1 se t1 (elemento atual) < s0 (menor valor), se nao recebe 0.
			beq $t4, $zero, inc_i2 #se t4 for 0 significa que o elemento atual nao e menor que o menor elemento ate agora portanto o valor de s0 nao muda e seguimos para o proximo loop. Se nao :
			addi $s0, $t1, 0 #o menor elemento passa a ser o elemento atual
			
		inc_i2:	addi $t2, $t2, 1 #i++
			bne $a0, $t2, loop_2
			
	fim_2:	add $v0, $s0, $zero #armazenando o valor de retorno (menor elemento) em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador	
		
		
	numero_elementos_pares_vetor:
		
		addi $sp, $sp, -4 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		
		la $t0, vet # endereço base do vetor
		addi $t1, $zero, 0 # i = 0
		addi $s0, $zero, 0 # numero_de_elementos_pares = 0
		addi $t4, $zero, 2 # constante 2
		
		loop_3:
			sll $t2, $t1, 2 # t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &vetor[i)	
			
			lw $t3, 0($t2) #t3 == elemento atual do vetor
			
			div $t3, $t4 #elemento_atual / 2
			mfhi $t3 #t3 == resto da divisao
			slt $t5, $zero, $t3 #Se t3 for zero o elemento atual é par e t5 sera setado para 0. Se t3 for 1 o elemento é impar e t5 sera setado para 1.
			bne $t5, $zero, inc_i3 #So queremos incrementar o contador abaixo caso o elemento atual seja par. Deste modo se t5 nao for 0 nao o incrementamos.
			addi $s0, $s0, 1 #numero_de_elementos_pares++
			
		inc_i3:	addi $t1, $t1, 1 #i++
			bne $t1, $a0, loop_3
	
		add $v0, $s0, $zero #armazenando o valor de retorno (numero de elementos pares) em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador
		
		
	maior_elemento_par_vetor:
	
		addi $sp, $sp, -4 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		
		la $t0, vet # endereço base do vetor
		addi $t1, $zero, 0 # i = 0
		addi $s0, $zero, 0 # maior_elemento_par = 0
		addi $t4, $zero, 2 # constante 2
		
		loop_4:
			sll $t2, $t1, 2 # t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &vetor[i)	
			
			lw $t3, 0($t2) #t3 == elemento atual do vetor
			
			div $t3, $t4 #elemento_atual / 2
			mfhi $t5 #t5 == resto da divisao
			slt $t6, $zero, $t5 #Se t5 for zero o elemento atual é par e t6 sera setado para 0. Se t5 for 1 o elemento é impar e t6 sera setado para 1.
			bne $t6, $zero, inc_i4 #So vamos fazer o teste abaixo caso o elemento atual seja par. Deste modo se t6 nao for 0 nao executamos o teste.
			
			slt $t7, $s0, $t3  #t7 recebe 1 se s0 (maior elemento par) < t3 (elemento par atual) , se nao recebe 0.
			beq $t7, $zero, inc_i4 #se t7 for 0 significa que o elemento par atual nao e maior que o maior elemento par ate agora, portanto, o valor de s0 nao muda e seguimos para o proximo loop. Se nao :
			addi $s0, $t3, 0 #o maior elemento par passa a ser o elemento par atual
			
		inc_i4:	addi $t1, $t1, 1 #i++
			bne $t1, $a0, loop_4
	
		add $v0, $s0, $zero #armazenando o valor de retorno (maior elemento par) em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador
		
	
	menor_elemento_impar_vetor:
	
		addi $sp, $sp, -4 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		
		la $t0, vet # endereço base do vetor
		addi $t1, $zero, 0 # i = 0
		addi $s0, $zero, 999999 # menor_elemento_impar = 999999
		addi $t4, $zero, 2 # constante 2
		
		loop_5:
			sll $t2, $t1, 2 # t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &vetor[i)	
			
			lw $t3, 0($t2) #t3 == elemento atual do vetor
			
			div $t3, $t4 #elemento_atual / 2
			mfhi $t5 #t5 == resto da divisao
			slt $t6, $zero, $t5 #Se t5 for 1 o elemento atual é impar e t6 sera setado para 1. Se t5 for zero o elemento é par e t6 sera setado para 0.
			beq $t6, $zero, inc_i5 #So vamos fazer o teste abaixo caso o elemento atual seja impar. Deste modo se t6 nao for 1 nao executamos o teste.
			
			slt $t7, $t3, $s0  #t7 recebe 1 se t3 (elemento impar atual) < s0 (menor elemento impar), se nao recebe 0.
			beq $t7, $zero, inc_i5 #se t7 for 0 significa que o elemento impar atual nao e menor que o menor elemento impar ate agora portanto o valor de s0 nao muda e seguimos para o proximo loop. Se nao :
			addi $s0, $t3, 0 #o menor elemento impar passa a ser o elemento atual
			
		inc_i5:	addi $t1, $t1, 1 #i++
			bne $t1, $a0, loop_5
	
		add $v0, $s0, $zero #armazenando o valor de retorno (menor elemento impar) em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador
		
		
	soma_elementos_impares_vetor:
	
		addi $sp, $sp, -4 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		
		la $t0, vet # endereço base do vetor
		addi $t1, $zero, 0 # i = 0
		addi $s0, $zero, 0 # soma_elementos_impares = 0
		addi $t4, $zero, 2 # constante 2
		
		loop_6:
			sll $t2, $t1, 2 # t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &vetor[i)	
			
			lw $t3, 0($t2) #t3 == elemento atual do vetor
			
			div $t3, $t4 #elemento_atual / 2
			mfhi $t5 #t5 == resto da divisao
			slt $t6, $zero, $t5 #Se t5 for 1 o elemento atual é impar e t6 sera setado para 1. Se t5 for zero o elemento é par e t6 sera setado para 0.
			beq $t6, $zero, inc_i6 #So vamos executar a soma abaixo caso o elemento atual seja impar. Deste modo se t6 nao for 1 nao somamos.
			
			add $s0, $s0, $t3 #soma_elementos_impares += elemento_impar_atual
			
		inc_i6:	addi $t1, $t1, 1 #i++
			bne $t1, $a0, loop_6
	
		add $v0, $s0, $zero #armazenando o valor de retorno (maior elemento par) em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador
		
		
	produto_elementos_pares_vetor:
	
		addi $sp, $sp, -4 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		
		la $t0, vet # endereço base do vetor
		addi $t1, $zero, 0 # i = 0
		addi $s0, $zero, 1 # produto_elementos_pares = 1
		addi $t4, $zero, 2 # constante 2
		
		loop_7:
			sll $t2, $t1, 2 # t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &vetor[i)	
			
			lw $t3, 0($t2) #t3 == elemento atual do vetor
			
			div $t3, $t4 #elemento_atual / 2
			mfhi $t5 #t5 == resto da divisao
			slt $t6, $zero, $t5 #Se t5 for zero o elemento atual é par e t6 sera setado para 0. Se t5 for 1 o elemento é impar e t6 sera setado para 1.
			bne $t6, $zero, inc_i7 #So vamos executar o produto abaixo caso o elemento atual seja par. Deste modo se t6 nao for 0 nao executamos o produto.
			
			mult $s0, $t3 
			mflo $s0  #multiplicamos o fator produto_elementos_pares pelo fator elemento par atual e guardamos em produto_elementos_pares
			
		inc_i7:	addi $t1, $t1, 1 #i++
			bne $t1, $a0, loop_7
	
		add $v0, $s0, $zero #armazenando o valor de retorno (produto elementos pares) em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador
		
