#Nome: Vitor G. S. Ruffo | #Atividade 9

.data
	mat: 		.space 64 # 4x4 * 4	
	
	Ent1: 	.asciiz " Insira o valor de mat["
	Ent2: 	.asciiz "]["
	Ent3: 	.asciiz "]: "
	
	maior_msg:	.asciiz "\nO maior elemento da matriz é: "
	menor_msg: 	.asciiz "\nO menor elemento da matriz é: "
	_i: 		.asciiz "i: "
	_j: 		.asciiz "j: "
	
	pares_msg:	.asciiz "\nO numero de elementos pares da matriz é: "
	primos_msg: .asciiz "\nO numero de elementos primos da matriz é: "
	
	ord_msg:	.asciiz "\nMatriz em ordem crescente: "
	
.text
	main: 
		la $a0, mat
		li $a1, 4 #a1 = nlin
		li $a2, 4 #a2 = ncol
	
	
		####Lendo a matriz####
		jal leitura
		move $a0, $v0
	
	
		####Imprimindo a matriz lida####
		jal escrita
		move $a0, $v0
	
	
		####Encontrando o maior elemento da matriz####
		la $a0, maior_msg
		addi $v0, $zero, 4
		syscall #"O maior elemento da matriz é: "
		
		la $a0, mat
		la $a3, e_maior 
		jal elemento_x_da_matriz
		
		
		####Encontrando o menor elemento da matriz####
		la $a0, menor_msg
		addi $v0, $zero, 4
		syscall #"O menor elemento da matriz é: "
		
		la $a0, mat
		la $a3, e_menor
		jal elemento_x_da_matriz
	
	
		####Encontrando o numero de elementos pares da matriz####
	
		la $a0, mat
		la $a3, e_par
		jal numero_elementos_y_da_matriz
		addi $s0, $v0, 0
		
		la $a1, pares_msg
		addi $a2, $s0, 0
		jal imprimir_string_seguida_de_inteiro
		addi $a1, $zero, 4
		addi $a2, $zero, 4
		
		####Encontrando o numero de elementos primos da matriz####
		
		la $a0, mat
		la $a3, e_primo
		jal numero_elementos_y_da_matriz
		addi $s1, $v0, 0
		
		la $a1, primos_msg
		addi $a2, $s1, 0
		jal imprimir_string_seguida_de_inteiro
		addi $a1, $zero, 4
		addi $a2, $zero, 4
	
		####Ordenando a matriz em ordem crescente####
		
		la $a0, mat
		jal gnome_sort
		
		la $a0, ord_msg
		addi $v0, $zero, 4
		syscall #"Matriz em ordem crescente: "
		
		la $a0, mat
		jal escrita
	
		####Finalizando o programa####
		li $v0, 10
		syscall 
	
	
	indice: #(a0 = endereço base de mat, a1 = nlin, a2 = ncol) -> calcula o endereço do elemento mat[i][j]
	 
		mul $v0, $t0, $a2  # i * ncol (calcula a posicao do inicio da linha i)
		add $v0, $v0, $t1  # (i * ncol) + j (calcula a posicao do elemento em sua linha)
		sll $v0, $v0, 2    # [(i * ncol) + j] (calcula o deslocamento em bytes para se chegar no elemento mat[i][j])
		add $v0, $v0, $a0  #retona a soma do endereço base da matriz e do deslocamento (i.e, return &mat[i][j])
		jr $ra 


	leitura:
		subi $sp, $sp, 4
		sw $ra, ($sp) #ja que vamos chamar um procedimento precisamos salvar o endereço de retorno de "leitura" na pilha.
		move $a3, $a0
	
		l: 
			la $a0, Ent1
			li $v0, 4
			syscall # " Insira o valor de Mat["
	    
      		move $a0, $t0
			li $v0, 1
			syscall # i
	
			la $a0, Ent2
			li $v0, 4
			syscall #"]["
	
			move $a0, $t1
			li $v0, 1
			syscall # j
	
			la $a0, Ent3
			li $v0, 4
			syscall # "]: "
	
			li $v0, 5
			syscall #lendo o valor de Mat[i][j]
			move $t2, $v0 #t2 = valor
			
			la $a0, ($a3)
			jal indice #calculando endereço de Mat[i][j]
			sw $t2, ($v0) #Mat[i][j] = t2
	
			addi $t1, $t1, 1 #j++
			blt $t1, $a2, l #if j<ncol, goto l
	
			li $t1, 0 # j = 0
			addi $t0, $t0, 1 #i++
			blt $t0, $a1, l #if i<nlin, goto l
	
		li $t0, 0 # i = 0
		lw $ra, ($sp) #recuperando o endereço de retorno para a main
		addi $sp, $sp, 4
		move $v0, $a3 #retornando o endereço base da matriz lida.
		jr $ra
	
	
	escrita: #(a0 = endereço base da matriz, a1 = nlin, a2 = ncol)
		subi $sp, $sp, 4
		sw $ra, ($sp)
		move $a3, $a0 #a3 = endereço base de mat
	
		la $a0, 10 #10 == codigo ASCII para '\n'
		li $v0, 11
		syscall #" "
	
		e: 
			la $a0, ($a3)
			jal indice #calculando endereço de Mat[i][j]
			lw $a0, ($v0)
			li $v0, 1
			syscall #imprime mat[i][j]
	
			la $a0, 32 #32 == codigo ASCII para white space
			li $v0, 11
			syscall #" "
	
			addi $t1, $t1, 1 #j++
			blt $t1, $a2, e #if j<ncol, goto e
 	
			la $a0, 10 #10 == codigo ASCII para newline ('\n')
			syscall #"\n"
	
			li $t1, 0 #j = 0
			addi $t0, $t0, 1 #i++
			blt $t0, $a1, e #if i<nlin, goto e
			li $t0, 0 #i = 0
	 
		lw $ra, ($sp)
		addi $sp, $sp, 4
		move $v0, $a3
		jr $ra


	elemento_x_da_matriz: #(a0 = endereço base de mat, a1 = nlin, a2 = ncol, a3 = endereço do procedimento que sera chamado para todos os elementos de mat afim de encontrar o elemento x)
		
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		
		la $s0, ($a0) #s0 = endereço base da matriz.
		addi $t0, $zero, 0 # i = 0
		addi $t1, $zero, 1 # j = 1
		
		lw $t2, ($s0) #t2 (elemento x) = mat[0][0]
		addi $t8, $zero, 0 #t8 = indice i do elemento x
		addi $t9, $zero, 0 #t9 = indice j do elemento x
		
		loop_elem_x:
			la $a0, ($s0)
			jal indice #calcula o endereço de mat[i][j]
			lw $t3, ($v0) #t3 = mat[i][j]
			
			addi $sp, $sp, -4
			sw $a1, 0($sp) #empilhando um dos parametros do procedimento atual.
			addi $a0, $t3, 0 
			addi $a1, $t2, 0
			jalr $a3 #testando se o elemento atual é X.
			lw $a1, 0($sp)
			addi $sp, $sp, 4
			
			beq $v0, $zero, elem_x_inc_j #if $v0 == 0 (o elemento atual mat[i][j] nao é o X), then goto elem_x_inc_j, else mat[i][j] passa a ser o elemento X.
			addi $t2, $t3, 0 #elemento_x = mat[i][j]
			addi $t8, $t0, 0 #t8 = indice i do elemento x
			addi $t9, $t1, 0 #t9 = indice j do elemento x
			
			elem_x_inc_j:
			addi $t1, $t1, 1 #j++
			slt $t3, $t1, $a2
			bne $t3, $zero, loop_elem_x #if j<ncol, goto loop_elem_x
	
			elem_x_inc_i:
			addi $t1, $zero, 0 #j = 0
			addi $t0, $t0, 1 #i++
			slt $t3, $t0, $a1
			bne $t3, $zero, loop_elem_x #if i<nlin, goto loop_elem_x
			
			addi $t0, $zero, 0 #i = 0
		
		#printar o elemento x e seus indices i,j na matriz:
		
		addi $sp, $sp, -8
		sw $a1, 0($sp) 
		sw $a2, 4($sp) #empilhando os parametros a1 e a2 do procedimento atual.
		
		addi $a0, $t2, 0
		addi $v0, $zero, 1
		syscall #"elemento x"	
					
		la $a1, _i
		addi $a2, $t8, 0
		jal imprimir_string_seguida_de_inteiro #i: y
		
		la $a1, _j
		addi $a2, $t9, 0
		jal imprimir_string_seguida_de_inteiro #j: z
			
		lw $a1, 0($sp)
		lw $a2, 4($sp)
		addi $sp, $sp, 8
		
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
		
					
	e_maior: #(a0 = elemento1, a1 = elemento2) -> testa se o elemento1 é maior que o elemento2
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		
		slt $t0, $a1, $a0 #if (elemento1 > elemento2) then t0 = 1 else t0 = 0
		
		addi $v0, $t0, 0 
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		jr $ra 
	
	
	e_menor: #(a0 = elemento1, a1 = elemento2) -> testa se o elemento1 é menor que o elemento2
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		
		slt $t0, $a0, $a1 #if (elemento1 < elemento2) then t0 = 1 else t0 = 0
		
		addi $v0, $t0, 0 
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		jr $ra 
		
		
	numero_elementos_y_da_matriz: #(a0 = endereço base de mat, a1 = nlin, a2 = ncol, a3 = endereço do procedimento que sera chamado para todos os elementos de mat afim de encontrar quantos desses sao y)
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		
		la $s0, ($a0) #s0 = endereço base da matriz.
		addi $t0, $zero, 0 # i = 0
		addi $t1, $zero, 0 # j = 0
		addi $t2, $zero, 0 # t2 (numero_elementos_y) = 0
		
		loop_elems_y:
			la $a0, ($s0)
			jal indice #calcula o endereço de mat[i][j]
			lw $t3, ($v0) #t3 = mat[i][j]
			
			#Testar se o elemento atual (mat[i][j]) é y, se sim incrementar numero_elementos_y (t2):
			addi $a0, $t3, 0
			jalr $a3
			
			beq $v0, $zero, elems_y_inc_j #if (v0 == 0) mat[i][j] nao é y, entao incrementamos j e vamos testar o proximo elemento. Se nao, incrementamos t2 (numero_de_elementos_y):
			addi $t2, $t2, 1 #numero_elementos_y++
			
			elems_y_inc_j:
			addi $t1, $t1, 1 #j++
			slt $t3, $t1, $a2
			bne $t3, $zero, loop_elems_y #if j<ncol, goto loop_elems_y
			
			elems_y_inc_y:
			addi $t1, $zero, 0 #j = 0
			addi $t0, $t0, 1 #i++
			slt $t3, $t0, $a1
			bne $t3, $zero, loop_elems_y #if i<nlin, goto loop_elems_y
			
			addi $t0, $zero, 0 #i = 0
		
		addi $v0, $t2, 0 #retornando numero_elementos_y
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
					
	
	e_par: #(a0: numero) -> retorna 1 se o numero for par, se nao retorna 0
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
		
	
	e_primo: #(a0: numero) -> retorna 1 se o numero for primo, se nao retorna 0
		
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
		
		bne $t0, $s1, fim_primo #se a soma dos divisores for igual a 1, o numero e primo
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
	
	
	gnome_sort: #(a0 = endereço base de mat, a1 = nlin, a2 = ncol)
		#A representaçao de uma matriz na memoria é como a de um vetor, assim, nesse procedimento vamos trabalhar apenas com um indice como se essa estrutura fosse um vetor.
		addi $sp, $sp, -8
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		
		la $t0, ($a0) #t0 = endereço base
		mul $t1, $a1, $a2 #t1 (mat_length) = nlin * ncol
		addi $v0, $zero, 0, #i = 0
		
		sll $t1, $t1, 2          #t1 *= 4 -> t1 vai passar a guardar a quantidade de bytes necessarios para guardar mat_length elementos. e.g, mat_length == 16 elementos, ..., t1 = 16 * 4 bytes = 64 bytes
  		
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
	
	
	imprimir_string_seguida_de_inteiro: #($a1: string, $a2: inteiro)
		la $a0, 10 #10 == codigo ASCII para '\n'
		li $v0, 11
		syscall #"\n"
		
		addi $v0, $zero, 4 
		la $a0, ($a1) 
		syscall	
		addi $v0, $zero, 1
		add $a0, $a2, $zero
		syscall 
		
		la $a0, 10 #10 == codigo ASCII para '\n'
		li $v0, 11
		syscall #"\n"
		jr $ra #retornando o controle para o chamador
	
