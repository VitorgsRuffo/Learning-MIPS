#Nome: Vitor G. S. Ruffo | #Atividade 16.3

.data
	msg1: .asciiz "Calculando o hiperfatorial de n.\nInsira o valor n: "
	msg2: .asciiz "\n\nResultado: "
.text
	main: 
	
		la $a0, msg1
		jal ler_n
		addi $s0, $v0, 0   #s0 = n
		
		addi $a0, $s0, 0
		jal hiperfatorial #(n:int):int
		addi $s1, $v0, 0
		
		la $a0, msg2
		addi $a1, $s1, 0
		jal imprimir_string_seguida_de_inteiro
		
		######Fim do programa######
		li $v0, 10
		syscall 
		
		
		
		
		ler_n: #(mensagem:string):int
		
			addi $v0, $zero, 4
			syscall		#"exemplo: Insira um valor para N:"
		
			addi $v0, $zero, 5
			syscall
		
			jr $ra #retornando o controle para o chamador
		
		
		hiperfatorial: #(n:int):int
		
			addi $sp, $sp, -12
			sw $ra, 0($sp)
			sw $s0, 4($sp)
			sw $s1, 8($sp)
			
			addi $v0, $zero, 1
			beq $a0, $v0, fim_hiperfatorial #if(n == 1) return 1; (base case)
			
			addi $a1, $a0, 0
			jal pow #(base:int, expoente:int):int
			addi $s0, $v0, 0 #s0 = pow(n,n)
			
			addi $a0, $a0, -1
			jal hiperfatorial
			addi $s1, $v0, 0 #s1 = hiperfatorial(n-1)

			mult $s0, $s1
			mflo $v0 #return pow(n,n) * hiperfatorial(n-1);			 
			
			fim_hiperfatorial:
			lw $ra, 0($sp)  
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			addi $sp, $sp, 12  
			jr $ra 
		
				
		pow: #(base:int, expoente:int):int
		
			addi $sp, $sp, -8
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			
			addi $s0, $zero, 1 #s0 (resultado) = 1
			addi $s1, $zero, 0 #i = 0
			
			loop_pow:
				mult $s0, $a0
				mflo $s0         #s0 *= base
				
				addi $s1, $s1, 1 		#i++
				blt  $s1, $a1, loop_pow #if(i<expoente) goto loop_pow
			
			addi $v0, $s0, 0
			lw $s0, 0($sp)  
			lw $s1, 4($sp)
			addi $sp, $sp, 8
			jr $ra 
			
			
		imprimir_string_seguida_de_inteiro: #(a0 = string, a1 = inteiro )

			addi $v0, $zero, 4 
			syscall	
		
			addi $v0, $zero, 1
			addi $a0, $a1, 0
			syscall 
			jr $ra #retornando o controle para o chamador
