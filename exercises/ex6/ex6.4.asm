#Nome: Vitor G. S. Ruffo | #Atividade 11.4

.data
	msg1: .asciiz "\nDigite o numero: "
	msg2: .asciiz "\nO numero "
	msg3: .asciiz "e palindromo\n"
	msg4: .asciiz "nao e palindromo\n"
	numero: .space 50
	new_line: .ascii "\n"
	
.text
	main:
		##########Lendo o numero como uma string:###########
		la $a0, msg1
		la $a1, numero #passando como parametro o endereço da mensagem a ser impressa e o endereço do segmento de memoria que vai guardar da string a ser lida.
		jal leitura_string
		
		la $a0, numero
		jal tamanho_string
		add $s0, $zero, $v0 #recebendo o tamanho da string 
			
		
		########Verificando se o numero e palindromo:#######
		la $a0, numero   #parametro a0: endereço do numero (string).
		addi $a1, $s0, 0 #parametro a1: tamanho da string.
		jal e_palindromo
		addi $s1, $v0, 0 #recebendo o resultado da verificacao.
		
		beq $s1, $zero, nao_e_palindromo_msg
		la $s2, msg3
		b mensagem
		
		nao_e_palindromo_msg:
		la $s2, msg4
		
		mensagem:
		la $a0, msg2
		la $a1, ($s2)
		jal imprimir_string
		
		
		###########Finalizando o programa############
		addi $v0, $zero, 10
		syscall
		
		
		
		
	leitura_string:
	
		#Lendo uma string:
		#
		# - carregamos o codigo da operacao em $v0;
		# - carregamos o endereço do segmento de memoria que vai guardar a string em $a0;
		# - carregamos N em $a1.
		#
		# Obs: vao ser lidos N-1 caracteres e sera colocado um caracter terminador de string ('\0') no final.
		# Obs: o caracter \n tabem é lido da entrada (caso haja espaço para armazena-lo) 
		# 
		# Exemplos de leitura - string a ser lida: vitor\n
		#
		# 	N == 5 - leremos 4 caracteres: vito'\0'
		#	N == 6 - leremos 5 caracteres: vitor'\0'
		#	N >= 7 - leremos 6 caracteres: vitor\n'\0'
	
		li $v0, 4
		syscall
		
		addi $v0, $zero, 8
		la $a0, ($a1)
		addi $a1, $zero, 50
		syscall
	
		jr $ra
	
			
	tamanho_string: #(a0 = endereço da string)
		
		addi $sp, $sp, -4
		sw $s0, 0($sp) #empilhando registrador(es) save
		
		addi $s0, $zero, 0 #tamanho da string = 0
		la $t0, ($a0) #t0 = endereço base da string
		addi $t1, $zero, 0 #t1 = 0 (i = 0)
		
		lbu $t4, new_line #t4 = '\n'
		
		loop_tamanho:
			add $t2, $t1, $t0 # t2 = deslocamento + endereço base do vetor (t2 == &string[i])
			
			lbu $t3, 0($t2) #t3 = string[i]
			
			beq $t3, $t4, fim_tamanho #if (t3 == '\n') sair do loop
			beq $t3, $zero, fim_tamanho #if (t3 == '\0') sair do loop
				
			addi $s0, $s0, 1 #tamanho da string += 1
			addi $t1, $t1, 1 #i++
			j loop_tamanho
			
		fim_tamanho:
		add $v0, $s0, $zero #v0 = tamanho da string
		lw $s0, 0($sp) #desempilhando registrador(es) save
		addi $sp, $sp, 4 
		jr $ra
		
		
	imprimir_string: #(a0 = endereço da mensagem a ser impressa antes, a1 = endereço da string a ser impressa)
	
		addi $v0, $zero, 4
		syscall #"mensagem" 
		
		la $a0, ($a1)
		syscall #"a string a ser impressa"
		
		jr $ra
		
		
	e_palindromo:#(a0: endereço do numero (string), a1: tamanho da string)
		addi $sp, $sp, -20
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $s4, 16($sp)

		la $s0, ($a0) 	  #endereço base da string (numero)
		addi $s1, $zero, 0  #i = 0	
		addi $s3, $a1, 0    #s3 = tamanho da string
		addi $s2, $s3, -1  #j = tamanho-1
		addi $s4, $zero, 0  #e_palindromo = 0

		palindromo_loop:
			add $t0, $s0, $s1 #t0 = endereço base + deslocamento (i.e, &numero[i])
			lbu $t1, 0($t0)   #t1 = numero[i]
			
			add $t0, $s0, $s2 #t0 = endereço base + deslocamento (i.e, &numero[j])
			lbu $t2, 0($t0)   #t2 = numero[j]
			
			bne $t1, $t2, fim_palindromo
			
			addi $s1, $s1, 1 #i++
			addi $s2, $s2, -1 #j--
			
			blt $s1, $s2, palindromo_loop #if(i<j) continuar loop
			addi $s4, $s4, 1 #e_palindromo = 1
			
		fim_palindromo:
		addi $v0, $s4, 0 
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		addi $sp, $sp, 20
		jr $ra