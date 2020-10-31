#Nome: Vitor G. S. Ruffo | #PROGRAMA DE INTERCALAÇÃO DE STRINGS

.data
	msg1: .asciiz "Digite a primeria string: "
	msg2: .asciiz "Digite a segunda string: "
	msg3: .asciiz "String: "
	msg4: .asciiz "Intercalacao: "
	
	string1: .space 50
	string2: .space 50
	string_inter: .space 100
	
	new_line: .ascii "\n"
	
.text
	main:
		##########Lendo a primeira string:###########
		la $a0, msg1
		la $a1, string1 #passando como parametro o endereço da mensagem a ser impressa e o endereço do segmento de memoria que vai guardar da string a ser lida.
		jal leitura_string
		
		la $a0, string1
		jal tamanho_string
		add $s0, $zero, $v0 #calculando o tamanho da string 1
			
		la $a0, msg3
		la $a1, string1
		jal imprimir_string
		
		
		##########Lendo a segunda string:###########
		la $a0, msg2
		la $a1, string2 #passando como parametro o endereço da mensagem a ser impressa e o endereço do segmento de memoria que vai guardar da string a ser lida.
		jal leitura_string
		
		la $a0, string2
		jal tamanho_string
		add $s1, $zero, $v0 #calculando o tamanho da string 2
		
		la $a0, msg3
		la $a1, string2
		jal imprimir_string
		
		
		########Intercalando as duas strings:#######
		
		add $a0, $zero, $s0
		add $a1, $zero, $s1 #passando o tamanho das strings como argumento.
		la $a2, string1
		la $a3, string2 #passando o endereço das strings como argumento
		jal intercala_strings	
		
		la $a0, msg4
		la $a1, string_inter
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
	
	
	imprimir_string: #(a0 = endereço da mensagem a ser impressa antes, a1 = endereço da string a ser impressa)
	
		addi $v0, $zero, 4
		syscall #"String: " 
		
		la $a0, ($a1)
		syscall #"a string a ser impressa"
		
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
	
	
	intercala_strings: #(a0 = tamanho da string 1, a1 = tamanho da string 2, a2 = endereço string 1, a3 = endereço string 2)
		
		addi $sp, $sp, -12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		
		#quatro variaveis necessarias: tamanhoStringMaior ($s1), tamanhoStringMenor ($s0), endereçoStringMaior ($t1), endereçoStringMenor ($t0)
	
	if:	slt $t2, $a1, $a0   #if (length(string1) > length(string2)) t2 = 1; else t2 = 0;
		beq $t2, $zero, else 
		
		addi $s1, $a0, 0 #tamanhoStringMaior = tamanho da string 1
		la $t1, ($a2) # endereçoStringMaior = endereço string 1
		
		addi $s0, $a1, 0 #tamanhoStringMenor = tamanho da string 2
		la $t0, ($a3) # endereçoStringMenor = endereço string 2
		j next
	
	else:   addi $s1, $a1, 0 #tamanhoStringMaior = tamanho da string 2
		la $t1, ($a3) # endereçoStringMaior = endereço string 2
		
		addi $s0, $a0, 0 #tamanhoStringMenor = tamanho da string 1
		la $t0, ($a2) # endereçoStringMenor = endereço string 1
		
	next:  	addi $t2, $zero, 0 #i = 0;
		addi $t3, $zero, 0 #j = 0;
		la $s2, string_inter #s2 = endereço base da string de saida do procedimento
		
		loop1_intercala: #de i=0 até length(stringMenor) - 1
		
			add $t4, $t2, $t0 # t4 = deslocamento i + endereço base string menor (t4 == &menor[i])
			add $t5, $t2, $t1 # t5 = deslocamento i + endereço base string maior (t5 == &maior[i])
								
			lbu $t6, 0($t4) #t6 = stringMenor[i]
			lbu $t7, 0($t5) #t7 = stringMaior[i]
			
			add $t9, $t3, $s2 # t9 = deslocamento j + endereço base string_inter (t9 == &string_inter[j])
			sb $t6, ($t9) #guarda o byte (caractere) atual da stringMenor na string_intercala
			
			addi $t3, $t3, 1 #j++
			add $t9, $t3, $s2 # t9 = deslocamento j + endereço base string_inter (t9 == &string_inter[j])
			sb $t7, ($t9) #guarda o byte (caractere) atual da stringMaior na string_intercala
			addi $t3, $t3, 1 #j++

			addi $t2, $t2, 1 #i++
			slt $t8, $t2, $s0 #se t2(i) < tamanhoStringMenor continuar loop
			bne $t8, $zero, loop1_intercala
			
		loop2_intercala: #do i atual até length(stringMaior) - 1
			
			slt $t8, $t2, $s1 #se t2(i) >= tamanhoStringMaior sair do loop
			beq $t8, $zero, fim
			
			add $t5, $t2, $t1 # t5 = deslocamento i + endereço base string maior (t5 == &maior[i])
		 	lbu $t7, 0($t5) #t7 = stringMaior[i]
		 	
		 	add $t9, $t3, $s2 # t9 = deslocamento j + endereço base string_inter (t9 == &string_inter[j])
			sb $t7, ($t9) #guarda o byte (caractere) atual da stringMaior na string_intercala
			addi $t3, $t3, 1 #j++
			
			addi $t2, $t2, 1 #i++
			j loop2_intercala
	
	fim:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		jr $ra