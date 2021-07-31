#Nome: Vitor G. S. Ruffo | #Atividade 16.2

.data
	msgn: .asciiz "\nInsira n: "
	msga: .asciiz "\nInsira a: "
	msgb: .asciiz "\nInsira b: "
	msgM: .asciiz "\n\nMultiplos:\n"

.text
	main: 
	
		la $a0, msgn
		jal ler_n
		addi $s0, $v0, 0   #s0 = n
		
		la $a0, msga
		jal ler_n
		addi $s1, $v0, 0   #s1 = a
		
		la $a0, msgb
		jal ler_n
		addi $s2, $v0, 0   #s2 = b
		
		addi $a0, $s0, 0
		addi $a1, $s1, 0
		addi $a2, $s2, 0
		jal n_multiplos_a_b #(n:int, a:int, b:int):void
		
		
		######Fim do programa######
		li $v0, 10
		syscall 
		
		
		
		
		ler_n: #(mensagem:string):int
		
			addi $v0, $zero, 4
			syscall		#"exemplo: Insira um valor para N:"
		
			addi $v0, $zero, 5
			syscall
		
			jr $ra #retornando o controle para o chamador
		
				
		n_multiplos_a_b: #(n:int, a:int, b:int):void
		
			addi $sp, $sp, -12
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			sw $s2, 8($sp)
			
			addi $s0, $a0, 0   #s0 = n
			addi $s1, $a1, 0   #s1 = a
			addi $s2, $a2, 0 	 #s2 = b
			addi $t0, $zero, 0 #t0 (i) = 0
			addi $t2, $zero, 0 #t2 (contador de multiplos impressos) = 0
			
			
			addi $v0, $zero, 4
			la $a0, msgM
			syscall
			
			loop_multiplos:
				add $t0, $t0, 1 #i++
			
				div $t0, $s1
				mfhi $t1
				beq $t1, $zero, imprimir_multiplo #if(i%a == 0) goto imprimir_multiplo
				
				div $t0, $s2
				mfhi $t1
				beq $t1, $zero, imprimir_multiplo #if(i%b == 0) goto imprimir_multiplo
				
				j inc_i
				
				imprimir_multiplo:
				addi $v0, $zero, 1
				addi $a0, $t0, 0
				syscall    #i
				
				li $v0, 11          #11 == codigo para impressao de caractere
				addi $a0, $zero, 32 #32 == codigo ASCII para white space
				syscall    #" "
				
				addi $t2, $t2, 1 #contador++
				
				inc_i:
				blt $t2, $s0, loop_multiplos
		
			fim_multiplos:
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
