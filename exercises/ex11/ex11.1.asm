#Nome: Vitor G. S. Ruffo | #Atividade 16.1

.data
	msgn: .asciiz "Insira n: "
	alfabeto: .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	
.text
	main: 
	
		la $a0, msgn
		jal ler_n
		addi $s0, $v0, 0   #s0 = n
		
		la $a0, alfabeto
		addi $a1, $s0, 0
		jal permutar_alfabeto #(alfabeto:address, n:int):void
		
		
		######Fim do programa######
		li $v0, 10
		syscall 
		
		
		
		
		ler_n: #(mensagem:string):int
		
			addi $v0, $zero, 4
			syscall		#"exemplo: Insira um valor para N:"
		
			addi $v0, $zero, 5
			syscall
		
			jr $ra #retornando o controle para o chamador
		
		
		permutar_alfabeto: #(alfabeto:address, n:int):void
			
			addi $sp, $sp, -12
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			sw $ra, 8($sp)
			
			add $s0, $a0, $a1 
			lb $s1, 0($s0)
			sb $zero, 0($s0) 	#colocando o caractere '\0' no lugar do caractere de indice n.
			
			addi $a2, $a1, -1
			addi $a1, $zero, 0
			jal permutar	#(string:address, start:int, end:int):void
			
			sb $s1, 0($s0)   	#recuperando o caractere do alfabeto que estava na posicao n.	
			
			lw $s0, 0($sp)  
			lw $s1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
			jr $ra
						
															
		permutar: #(string:address, start:int, end:int):void
			addi $sp, $sp, -20
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			sw $s2, 8($sp)
			sw $s3, 12($sp)
			sw $ra, 16($sp)
			
			addi $s0, $a0, 0 #s0 = endereço string
			addi $s1, $a1, 0 #s1 = indice do inicio da string
			addi $s2, $a2, 0 #s2 = indice do final da string
			
			bne $s1, $s2, permutar_else #if(start == end)
			
			addi $v0, $zero, 4 
			syscall
			
			addi $a0, $zero, 10 #10 == codigo ASCII para newline ('\n')
			li $v0, 11
			syscall #"\n"
			
			j fim_permutar
			
			permutar_else:
			addi $s3, $s1, 0 #i = start
			
			loop_permutar:
				add $a0, $s0, $s1
				add $a1, $s0, $s3
				jal swap_bytes #(byte1:address, byte2:address):void
				
				addi $a0, $s0, 0
				addi $a1, $s1, 1
				addi $a2, $s2, 0
				jal permutar
				
				add $a0, $s0, $s1
				add $a1, $s0, $s3
				jal swap_bytes #(byte1:address, byte2:address):void
				
				addi $s3, $s3, 1 #i++
				ble $s3, $s2, loop_permutar #if(i<=end) goto loop_permutar 
			
			fim_permutar:
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $ra, 16($sp)
			addi $sp, $sp, 20
			jr $ra
			
			
		swap_bytes: #(byte1:address, byte2:address):void
			addi $sp, $sp, -8
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			
			lb $s0, 0($a0)
			lb $s1, 0($a1)
			sb $s1, 0($a0)     
    			sb $s0, 0($a1)
    			
    			lw $s0, 0($sp)  
			lw $s1, 4($sp)
			addi $sp, $sp, 8
			jr $ra