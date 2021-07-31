	#Nome: Vitor G. S. Ruffo | #Atividade 15.2

.data
	vetor:		.space 400
	buffer: 		.space 100
	caminhoArquivo: 	.asciiz "dados2.txt" #arquivo com inteiros separador por '\n', e.g: 1\n2\n3\n4
	msgErro: 		.asciiz "O arquivo não foi encontrado.\n"
	msg1: 		.asciiz "Conteudo do arquivo:\n"
	new_line: 		.asciiz "\n"
	
	msg2:  .asciiz "\n\nVetor:\n"
	msg3:  .asciiz "\nvet["
	msg4:  .asciiz "] = "
	msg5:  .asciiz "\n\nMaior elemento do arquivo: "
	msg6:  .asciiz "\n\nMenor elemento do arquivo: "
	msg7:  .asciiz "\n\nNumero de elementos pares do arquivo: "
	msg8:  .asciiz "\n\nNumero de elementos impares do arquivo: "
	msg9:  .asciiz "\n\nSoma dos elementos do arquivo: "
	msg10: .asciiz "\n\nProduto dos elementos do arquivo: "
	msg11: .asciiz "\n\nElementos do arquivo em ordem crescente:\n"
	msg12: .asciiz "\n\nElementos do arquivo em ordem decrescente:\n"
	msg13: .asciiz "\n\nNumero de caracteres no arquivo: "
	
.text
	main:
		
		########A#####brindo o arquivo###############
		la $a0, caminhoArquivo
		addi $a1, $zero, 0 #flag de abertura do arquivo:  0 for read-only, 1 for write-only with create, and 9 for write-only with create and append.
		jal abrir_arquivo #((a0) caminhoArquivo:string, (a1) flag: int):int
		addi $s0, $v0, 0 #s0 = descritor do arquivo.

		#se descritor < 0 entao ocorreu um erro ao abrir o arquivo.
						
		bge $s0, $zero, ler_main #if(s0 >= 0) goto ler_main  
			
		addi $v0, $zero, 4
		la $a0, msgErro
		syscall #"O arquivo não foi encontrado.\n"
		
		j fim_main
		
		
		#############Lendo o arquivo#################
		ler_main:
		addi $v0, $zero, 14 #codigo para leitura do arquivo
		addi $a0, $s0, 0 #a0 = file descriptor
		la $a1, buffer   #a1 = endereço do buffer que recebera os dados do arquivo
		addi $a2, $zero, 100 #a2 = quantidade max de caracteres que serao lidos na chamada de sistema.
		syscall
		addi $t9, $v0, 0
			
		la $a0, msg1
		la $a1, buffer
		jal imprimir_string
		
		la $a0, buffer
		la $a1, vetor
		jal converter_buffer_para_vetor
		addi $s1, $v0, 0 #s1 = tamanho do vetor

		#la $a0, vetor
		#addi $a1, $s1, 0
		#la $a2, msg2
		#jal imprimir_vetor #(vetor:address, tamanhoVetor:int, mensagem:string):void
			
			#maior e menor valor do arquivo:
			la $a0, vetor
			addi $a1, $s1, 0
			jal maior_elemento_vetor
			addi $a1, $v0, 0
			la $a0, msg5
			jal imprimir_string_seguida_de_inteiro #(a0 = string, a1 = inteiro )
			
			la $a0, vetor
			addi $a1, $s1, 0
			jal menor_elemento_vetor
			addi $a1, $v0, 0
			la $a0, msg6
			jal imprimir_string_seguida_de_inteiro #(a0 = string, a1 = inteiro )
			
			#numero de elementos pares e impares:
			la $a0, vetor 	       #passando o endereço base do vetor como parametro
			addi $a1, $s1, 0  	 #passando o numero de elementos do vetor como parametro
			la $a2, o_numero_e_par   #passando o endereço do teste a ser executado em cada elemento
			jal numero_elementos_x_vetor
			addi $a1, $v0, 0
			la $a0, msg7
			jal imprimir_string_seguida_de_inteiro #(a0 = string, a1 = inteiro )
			
			la $a0, vetor 	         #passando o endereço base do vetor como parametro
			addi $a1, $s1, 0  	   #passando o numero de elementos do vetor como parametro
			la $a2, o_numero_e_impar   #passando o endereço do teste a ser executado em cada elemento
			jal numero_elementos_x_vetor
			addi $a1, $v0, 0
			la $a0, msg8
			jal imprimir_string_seguida_de_inteiro #(a0 = string, a1 = inteiro )
			
			#soma e produto dos elementos:
			la $a0, vetor 	       #passando o endereço base do vetor como parametro
			addi $a1, $s1, 0  	 #passando o numero de elementos do vetor como parametro
			jal soma_elementos_vetor
			addi $a1, $v0, 0
			la $a0, msg9
			jal imprimir_string_seguida_de_inteiro #(a0 = string, a1 = inteiro )
			
			la $a0, vetor 	       #passando o endereço base do vetor como parametro
			addi $a1, $s1, 0  	 #passando o numero de elementos do vetor como parametro
			jal produto_elementos_vetor
			addi $a1, $v0, 0
			la $a0, msg10
			jal imprimir_string_seguida_de_inteiro #(a0 = string, a1 = inteiro )
			
			
			#valores em ordem crescente/decrescente:
			la $a0, vetor 	       #passando o endereço base do vetor como parametro
			addi $a1, $s1, 0  	 #passando o numero de elementos do vetor como parametro
			jal gnome_sort
			
			la $a0, vetor 	       #passando o endereço base do vetor como parametro
			addi $a1, $s1, 0  	 #passando o numero de elementos do vetor como parametro
			la $a2, msg11
			jal imprimir_vetor
			
			la $a0, vetor 	       #passando o endereço base do vetor como parametro
			addi $a1, $s1, 0  	 #passando o numero de elementos do vetor como parametro
			la $a2, msg12
			jal imprimir_vetor_invertido
		
		
			#Contando o numero de caracteres:
			la $a0, buffer
			jal contar_caracteres_buffer
			addi $a1, $v0, 0
			la $a0, msg13
			jal imprimir_string_seguida_de_inteiro #(a0 = string, a1 = inteiro )
			
			
		###########Finalizando o programa############
		fim_main:
		
		addi $a0, $s0, 0
		jal fechar_arquivo #((a0) descritor:int):void
		
		addi $v0, $zero, 10
		syscall
		
		
		
		
		abrir_arquivo: #((a0) caminhoArquivo:string, (a1) flag: int):int
			
			addi $v0, $zero, 13 #codigo de abertura de arquivos.
			syscall
			jr $ra
			
			
		fechar_arquivo: #((a0) descritor:int):void
		
			addi $v0, $zero, 16 #codigo para fechamento do arquivo
			syscall
			jr $ra
			
		
		converter_buffer_para_vetor: #((a0) buffer:address, (a1) vetor:address):int
			
			addi $sp, $sp, -12
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			sw $ra, 8($sp)
			
			la $s0, ($a0)      #s0 = endereço buffer
			addi $t0, $zero, 0 #t0 (j) = 0
			la $t2, ($a0)      #t2 = endereço de um inteiro em (forma de string) no buffer.
	
			la $s1, ($a1)      #s1 = endereço vetor
			addi $t1, $zero, 0 #t1 (i) = 0	
			
			addi $t3, $zero, 10 #10 is the ASCII code for representing new line
			addi $t4, $zero, 32 #32 is the ASCII code for representing white space
				 
			
			loop_converter:
				add $t5, $s0, $t0 #t5 = endereço buffer + deslocamento (t5 = &buffer[j])
				lbu $t6, 0($t5)   #t6 = buffer[j]
				
				beq $t6, $zero, ultima_conversao #if(buffer[j] == '\0') goto ...
		
				bne $t6, $t3, inc_j  #if(buffer[j] != '\n') goto inc_j
				lbu $t6, 1($t5)     			     #t6 = buffer[j+1]
				beq $t6, $zero, ultimo_caracter_new_line #if(buffer[j+1] == '\0') goto ...
				
				
				sb $zero, 0($t5)  #buffer[j] = 0
				
				la $a0, ($t2)   
				jal stringToInt   #(numberString:address):int
				addi $t7, $v0, 0  #t7 = inteiro recem convertido
				
				sb $t3, 0($t5)  #buffer[j] = '\n'
								
				sll $t5, $t1, 2   #t5 = i * 4 (i.e, deslocamento)
				add $t5, $t5, $s1 #t5 += endereço vetor (t5 = &vetor[i])
				sw $t7, 0($t5)    #vetor[i] = t7
				addi $t1, $t1, 1  #i++
				
				add $t2, $s0, $t0 
				addi $t2, $t2, 1 #t2 = endereço buffer + j + 1
				
				
				inc_j:
				addi $t0, $t0, 1 #j++
				j loop_converter
		
			ultimo_caracter_new_line:
			sb $zero, 0($t5)  #buffer[j] = 0 
			
			ultima_conversao:
			la $a0, ($t2)   
			jal stringToInt   #(numberString:address):int
			addi $t7, $v0, 0  #t7 = inteiro recem convertido
						
			sll $t5, $t1, 2   #t5 = i * 4 (i.e, deslocamento)
			add $t5, $t5, $s1 #t5 += endereço vetor (t5 = &vetor[i])
			sw $t7, 0($t5)    #vetor[i] = t7
			addi $t1, $t1, 1  #i++
			
			
			addi $v0, $t1, 0  #v0 = tamanho do vetor
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
			jr $ra
			
			
		stringToInt: #(numberString:address):int
			addi $sp, $sp, -28
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			sw $t1, 8($sp)
			sw $t2, 12($sp)
			sw $t3, 16($sp)
			sw $t7, 20($sp)
			sw $t8, 24($sp)
						
			addi $s0, $zero, 0  #resultado = 0
			la $s1, ($a0)	  #s1 = endereço numero (string)
			addi $t1, $zero, 0  #t1 (i) = 0 
			addi $t7, $zero, 10 #t7 = contatante 10	
			addi $t8, $zero, 48 #t8 = 48 = '\0' ASCII code
																				
			loop_string_int:
				add $t2, $s1, $t1 #t2 = endereço string + deslocamento (t2 = &string[i])
				lbu $t3, 0($t2)   #t3 = string[i]
				
				beq $t3, $zero, fim_string_int #while(*string != '\0')
				
				#resultado = (resultado * 10) + (*string - '0');
				mult $s0, $t7
				mflo $s0	       #resultado *= 10
				
				sub $t2, $t3, $t8  #t2 = (*string - '0')
				add $s0, $s0, $t2 
				
				addi $t1, $t1, 1 #i++
				j loop_string_int
				
				
			fim_string_int:
			addi $v0, $s0, 0						
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $t1, 8($sp)
			lw $t2, 12($sp)
			lw $t3, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			addi $sp, $sp, 28
			jr $ra
			
			
		contar_caracteres_arquivo: #((a0) descritor:int, (a1) buffer:string):int
			addi $sp, $sp, -4
			sw $s0, 0($sp)
						
			addi $s0, $zero, 0 #contador (s0) = 0
		
			addi $a2, $zero, 1 #a2 = quantidade max de caracteres que serao lidos na chamada de sistema.
				
			contar_loop:
				addi $v0, $zero, 14 #codigo para leitura do arquivo
				syscall
				
				ble $v0, $zero, fim_contar #if(EOF OU erro) goto fim_contar
				
				addi $s0, $s0, 1 #contador++
				b contar_loop
						
			fim_contar:	
			addi $v0, $s0, -1						
			lw $s0, 0($sp)
			addi $sp, $sp, 4
			jr $ra
		

		contar_caracteres_buffer: #((a0) buffer:address):int
		
			addi $sp, $sp, -4
			sw $s0, 0($sp) 
		
			addi $s0, $zero, 0 #contador = 0
			la $t0, ($a0) 	 #t0 = endereço base da string
			addi $t1, $zero, 0 #t1 = 0 (i = 0)
		
			loop_contar_buffer:
				add $t2, $t1, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &string[i])
			
				lbu $t3, 0($t2) #t3 = string[i]
			
				beq $t3, $zero, fim_contar_buffer #if (t3 == '\0') sair do loop
				
				addi $s0, $s0, 1 #tamanho da string += 1
				addi $t1, $t1, 1 #i++
				j loop_contar_buffer
			
			fim_contar_buffer:
			addi $v0, $s0, 0 #v0 = numero de caracteres no buffer
			lw $s0, 0($sp)
			addi $sp, $sp, 4 
			jr $ra
		
	
		imprimir_string: #(a0 = endereço da mensagem a ser impressa antes, a1 = endereço da string a ser impressa)
	
			addi $v0, $zero, 4
			syscall #"String: " 
		
			la $a0, ($a1)
			syscall #"a string a ser impressa"
		
			jr $ra
			
			
		imprimir_vetor:#(vetor:address, tamanhoVetor:int, mensagem:string):void
	
		addi $sp, $sp, -28 #armazenando valores de s0/t0-t4/ra na pilha
		sw $s0, 0($sp)
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		sw $t2, 12($sp)
		sw $t3, 16($sp)
		sw $t4, 20($sp)
		sw $ra, 24($sp)
						
		la $t0, ($a0) # t0 = endereço base do vetor
		addi $s0, $a1, 0 #s0 = tamanho do vetor
		addi $t2, $zero, 0 # i = 0
		
		addi $v0, $zero, 4
		la $a0, ($a2)
		syscall  #Vetor:
		
		print_loop:
			sll $t3, $t2, 2   # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i])	
			
			lw $t4, 0($t3)
			
			la $a0, msg3 
			addi $a1, $t2, 0 
			jal imprimir_string_seguida_de_inteiro #vetor[i
			
			la $a0, msg4
			addi $a1, $t4, 0  
			jal imprimir_string_seguida_de_inteiro#]=x
			
			addi $t2, $t2, 1 #i++
			bne $s0, $t2, print_loop #while(i<tamanhoVetor)
		
		lw $s0, 0($sp) #guardando os valores originais de volta em s0/t0-t3/ra
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		lw $t4, 20($sp)
		lw $ra, 24($sp)
		addi $sp, $sp, 28 #desempilhando s0/t0-t3/ra 
		jr $ra #retornando o controle para o chamador
	
	
	imprimir_vetor_invertido:#(vetor:address, tamanhoVetor:int, mensagem:string):void
	
		addi $sp, $sp, -28 #armazenando valores de s0/t0-t4/ra na pilha
		sw $s0, 0($sp)
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		sw $t2, 12($sp)
		sw $t3, 16($sp)
		sw $t4, 20($sp)
		sw $ra, 24($sp)
						
		la $t0, ($a0)       #t0 = endereço base do vetor
		addi $s0, $a1, 0    #s0 = tamanho do vetor
		addi $t2, $s0, -1   #i = tamanhoVetor-1
		addi $t1, $zero, -1 #t1 = -1 
		
		addi $v0, $zero, 4
		la $a0, ($a2)
		syscall  #mensagem:
		
		print_invertido_loop: #for(int i = tamanhoVetor-1; i >= 0; i--)
		
			sll $t3, $t2, 2   # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i])	
			
			lw $t4, 0($t3)
			
			la $a0, msg3 
			addi $a1, $t2, 0 
			jal imprimir_string_seguida_de_inteiro #vetor[i
			
			la $a0, msg4
			addi $a1, $t4, 0  
			jal imprimir_string_seguida_de_inteiro#]=x
			
			subi $t2, $t2, 1 #i--
			bne $t2, $t1 print_invertido_loop #while(i > -1)
		
		lw $s0, 0($sp) #guardando os valores originais de volta em s0/t0-t3/ra
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		lw $t4, 20($sp)
		lw $ra, 24($sp)
		addi $sp, $sp, 28 #desempilhando s0/t0-t3/ra 
		jr $ra #retornando o controle para o chamador
		
	
	imprimir_string_seguida_de_inteiro: #(a0 = string, a1 = inteiro )

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 
		jr $ra #retornando o controle para o chamador	
		
		
	maior_elemento_vetor: #((a0) vetor:address, (a1) tamanhoVetor:int):int
		
		addi $sp, $sp, -4 
		sw $s0, 0($sp) 
		
		la $t0, ($a0)  #endereço base do vetor
		lw $t1, 0($t0) #elemento atual do vetor
		
		addi $t2, $zero, 1 # i = 1 
		add $s0, $t1, $zero #maior elemento do vetor
		
		beq $a1, $t2, fim_maior #se vetor possuir somente um elemento ele sera o maior
		
		loop_maior:
			sll $t3, $t2, 2 # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i)	
			
			lw $t1, 0($t3)
			slt $t4, $s0, $t1  #t4 recebe 1 se s0 (maior elemento) < t1 (elemento atual) , se nao recebe 0.
			beq $t4, $zero, inc_i_maior #se t4 for 0 significa que o elemento atual nao e maior que o maior elemento ate agora portanto o valor de s0 nao muda e seguimos para o proximo loop. Se nao :
			addi $s0, $t1, 0 #o maior elemento passa a ser o elemento atual
			
			inc_i_maior:	
			addi $t2, $t2, 1 #i++
			bne $a1, $t2, loop_maior
			
		fim_maior:	
		add $v0, $s0, $zero #armazenando o valor de retorno (maior elemento) em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador
		
		
	menor_elemento_vetor:#((a0) vetor:address, (a1) tamanhoVetor:int):int
		
		addi $sp, $sp, -4 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		
		la $t0, ($a0) # endereço base do vetor
		lw $t1, 0($t0) #elemento atual do vetor
		
		addi $t2, $zero, 1 # i = 1 
		add $s0, $t1, $zero #menor elemento do vetor
		
		beq $a1, $t2, fim_menor #se vetor possuir somente um elemento ele sera o menor
		
		loop_menor:
			sll $t3, $t2, 2 # t3 = 4 * i (i.e, deslocamento)
			add $t3, $t3, $t0 # t3 = deslocamento + endereço base do vetor (t3 == &vetor[i)	
			
			lw $t1, 0($t3)
			slt $t4, $t1, $s0  #t4 recebe 1 se t1 (elemento atual) < s0 (menor valor), se nao recebe 0.
			beq $t4, $zero, inc_i_menor #se t4 for 0 significa que o elemento atual nao e menor que o menor elemento ate agora portanto o valor de s0 nao muda e seguimos para o proximo loop. Se nao :
			addi $s0, $t1, 0 #o menor elemento passa a ser o elemento atual
			
			inc_i_menor:	
			addi $t2, $t2, 1 #i++
			bne $a1, $t2, loop_menor
			
		fim_menor:	
		add $v0, $s0, $zero #armazenando o valor de retorno (menor elemento) em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador	
		
		
	numero_elementos_x_vetor: #((a0) vetor:address, (a1) tamanhoVetor:int, (a2) procedimento que diz se um numero é classificado como x ou nao:address):int
	
		addi $sp, $sp, -16 
		sw $s0, 0($sp) #preservando o valor de $s0 ao armazena-lo na pilha.
		sw $s1, 4($sp) #
		sw $s2, 8($sp) #
		sw $ra, 12($sp) ##se vamos chamar um procedimento dentro de outro precisamos salvar o endereço de retorno do chamador, pois, na hora do "jal X" o valor de $ra sera alterado.
		
		la $t0, ($a0)    #endereço base do vetor
		addi $s1, $a1, 0 #s1 = tamanho do vetor
		la $s2, ($a2)    #s2 = procedimento de teste
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
			
			beq $t4, $zero, inc_i_x # se t4 != 0 incrementamos o contador:
			addi $s0, $s0, 1 # numero_de_elementos_x++
			
			inc_i_x:	
			addi $t1, $t1, 1 #i++
			bne $t1, $s1, loop_x #if (i < tamanho do vetor) continuar loop.
	
		add $v0, $s0, $zero #armazenando o valor de retorno (numero de elementos x) em $v0
		lw $s0, 0($sp) 
		lw $s1, 4($sp) 
		lw $s2, 8($sp) 
		lw $ra, 12($sp) 
		addi $sp, $sp, 16
		jr $ra
		
	o_numero_e_par: #((a0) numero:int):int -> retorna 1 se o numero for par, se nao retorna 0
		addi $sp, $sp, -4
		sw $t2, 0($sp)
		
		addi $t2, $zero, 2 #contante 2
		
		div $a0, $t2 #numero / 2
		mfhi $t2 #t2 == resto da divisao
		
		addi $v0, $zero, 0
		
		bne $t2, $zero, fim_par # if (resto != 0) return 0 else return 1
		addi $v0, $v0, 1 
		
		fim_par:
		lw $t2, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
	o_numero_e_impar: #((a0) numero:int):int -> retorna 1 se o numero for impar, se nao retorna 0
		addi $sp, $sp, -4
		sw $t2, 0($sp)
		
		addi $t2, $zero, 2 #contante 2
		
		div $a0, $t2 #numero / 2
		mfhi $t2 #t2 == resto da divisao
		
		addi $v0, $zero, 0
		
		beq $t2, $zero, fim_impar # if (resto == 0) return 0 else return 1
		addi $v0, $v0, 1 
		
		fim_impar:
		lw $t2, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
	soma_elementos_vetor: #((a0) vetor:address, (a1) tamanhoVetor:int):int
	
		addi $sp, $sp, -4 
		sw $s0, 0($sp) 
		
		la $t0, ($a0) 	 # t0 = endereço base do vetor
		addi $t1, $zero, 0 # i = 0
		addi $s0, $zero, 0 # soma = 0
		
		loop_soma:
			sll $t2, $t1, 2 # t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &vetor[i])	
			
			lw $t3, 0($t2) #t3 == elemento atual do vetor
			
			add $s0, $s0, $t3 #soma_elementos += elemento_atual
			
			addi $t1, $t1, 1 #i++
			bne $t1, $a1, loop_soma
	
		add $v0, $s0, $zero #armazenando o valor de retorno (maior elemento) em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador
		
		
	produto_elementos_vetor: #((a0) vetor:address, (a1) tamanhoVetor:int):int
	
		addi $sp, $sp, -4 
		sw $s0, 0($sp) 
		
		la $t0, ($a0) 	 # t0 = endereço base do vetor
		addi $t1, $zero, 0 # i = 0
		addi $s0, $zero, 1 # produto = 1
		
		loop_produto:
			sll $t2, $t1, 2   # t2 = 4 * i (i.e, deslocamento)
			add $t2, $t2, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &vetor[i])	
			
			lw $t3, 0($t2)   #t3 == elemento atual do vetor
			
			mult $s0, $t3
			mflo $s0	     #produto_elementos *= elemento_atual
			
			addi $t1, $t1, 1 #i++
			bne $t1, $a1, loop_produto
	
		add $v0, $s0, $zero #armazenando o valor de retorno em $v0
		lw $s0, 0($sp)  #recuperando o valor de $s0 da pilha
		addi $sp, $sp, 4
		jr $ra #retornando o controle para o chamador
		
		
	gnome_sort: #((a0) vetor:address, (a1) tamanhoVetor:int):void
	
		addi $sp, $sp, -8
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		
		la $t0, ($a0) 	  #t0 = endereço base
		addi $t1, $a1, 0    #t1 = tamanho do vetor
		addi $v0, $zero, 0, #i = 0
		
		sll $t1, $t1, 2          #t1 *= 4 -> t1 vai passar a guardar a quantidade de bytes necessarios para guardar tamanhoVetor elementos. e.g, tamanhoVetor == 16 elementos, ..., t1 = 16 * 4 bytes = 64 bytes
  		
  		loop_gnome:
   	 		slt $t3, $v0, $t1        # if (i < n) => $t3 = 1
			beq $t3, $zero, fim_gnome      # while (i < n) {
			bne $v0, $zero, comparar_gnome  # if (i == 0)
			addiu $v0, $v0, 4          # i = i + 1
  		
  			comparar_gnome:
    			addu $t2, $t0, $v0        # $t2 = endereço base + deslocamento em bytes (=&arr[i])
    			lw $t4, -4($t2)         # $t4 = arr[i-1]
    			lw $t5, 0($t2)          # $t5 = arr[i]
    			blt $t5, $t4, swap_gnome       # swap if (arr[i] < arr[i-1])
    			addiu $v0, $v0, 4          # i = i + 1
    			j loop_gnome
  		
  			swap_gnome:
    			sw $t4, 0($t2)          # swap (arr[i], arr[i-1])
    			sw $t5, -4($t2)
    			addiu $v0, $v0, -4         # i = i - 1
    			j loop_gnome
  		
  		fim_gnome:
   		lw $t0, 0($sp)
   		lw $t1, 4($sp)           
  	 	addi $sp, $sp, 8           
   		jr $ra
