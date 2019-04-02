#Aluno: Rômulo de Vasconcelos Feijão Filho
#Matrícula: 14/0031260
#Professor: Ricardo Pezzuol Jacobi
#Disciplina: Organização e Arquitetura de Computadores
#Semestre: 2018/2

#Programa compilado no MARS versão 4.5
#Sistema operacional: OS X El Capitan - Versão 10.11.6

.data

	raiz: .word 8 a0 a1
	a0: .word 3 a2 a3
	a1: .word 10 0 a4
	a2: .word 1 0 0
	a3: .word 6 a5 a6
	a4: .word 14 a7 0
	a5: .word 4 0 0
	a6: .word 7 0 0
	a7: .word 13 0 0
	
.text

	main: 
		j funcao_exec_busca_recursiva
		#j funcao_exec_insere_rec
		
	funcao_exec_busca_recursiva:		#caso for usar a função de busca recursiva, deve-se chamar a funcao_exec_busca_recursiva
		addi $a0, $zero, 8192
		addi $v0, $zero, 5		
		syscall				#pede ao usuário valor a ser procurado
		add $s0, $zero, $v0
		jal busca_recursiva
		addi $v0, $zero, 1
		add $a0, $zero, $a1
		syscall
		addi $v0, $zero, 10
		syscall
		
	busca_recursiva:
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		add $a1, $zero, $a0
		lw $t0, 0($a0)
		addi $a0, $a0, 4
		lw $t1, 0($a0)
		sw $t1, 4($sp)
		addi $a0, $a0, 4
		lw $t2, 0($a0)
		sw $t2, 8($sp)
		beq $s0, $t0, retorna_endereco
		bgt $s0, $t0, muda_direita
		blt $s0, $t0, muda_esquerda
		
	retorna_endereco:
		jr $ra
		
	muda_direita:				#vai para o nó da direita da árvore para a função busca_recursiva
		lw $a0, 8($sp)
		addi $sp, $sp, 8
		j busca_recursiva
	
	muda_esquerda:				#vai para o nó da esquerda da árvore para a função busca_recursiva
		lw $a0, 4($sp)
		addi $sp, $sp, 8
		j busca_recursiva
		
	funcao_exec_size:			#função usada para usar somente a função size, no final ela irá printar o tamanho da árvore
		addi $a0, $zero, 8192
		jal size_rec
		addi $v0, $zero, 1
		add $a0, $zero, $a1
		syscall
		addi $v0, $zero, 10
		syscall
		
	size_rec:
		lw $t0, 0($a0)			#busca valor do nó guardado no .data
		beqz $t0, retorna_endereco	#se valor for igual a 0, então já passamos por todos os nós, então retornamos ao $ra
		addi $a1, $a1, 1		#se for diferente de 0, incrementa 1 ao registrador a1, que será usado para guardar o tamanho
		addi $a0, $a0, 12		#busca próximo nó no .data
		j size_rec
		
	funcao_exec_insere_rec:			#caso for usar a função de inserção, deve-se chamar a funcao_exec_insere_rec
		addi $a0, $zero, 8192
		addi $v0, $zero, 5
		syscall				#pede ao usuário valor a ser inserido
		jal size_rec
		addi $t0, $zero, 12
		mul $t8, $t0, $a1
		addi $t9, $t8, 8192
		sw $v0, 0($t9)
		addi $a0, $zero, 8192
		add $s1, $zero, $ra
		jal insere_rec
		addi $v0, $zero, 10
		syscall
		
	insere_rec:
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		add $a1, $zero, $a0
		lw $t0, 0($a0)
		addi $a0, $a0, 4
		lw $t1, 0($a0)
		beqz $t1, retorna_fim
		sw $t1, 4($sp)
		addi $a0, $a0, 4
		lw $t2, 0($a0)
		beqz $t2, retorna_fim
		sw $t2, 8($sp)
		bgt $v0, $t0, vai_direita
		blt $v0, $t0, vai_esquerda
		
	retorna_fim:				#insere o endereço do novo nó na árvore e encerra a execução
		sw $t9, 0($a0)
		jr $s1
		
	vai_direita:				#vai para o nó da direita da árvore para a função insere_rec
		lw $a0, 8($sp)
		addi $sp, $sp, 8
		j insere_rec
	
	vai_esquerda:				#vai para o nó da esquerda da árvore para a função insere_rec
		lw $a0, 4($sp)
		addi $sp, $sp, 8
		j insere_rec