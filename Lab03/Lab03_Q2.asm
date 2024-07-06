	.text
#-------------------------- Prelim Q2 ----------------------------	
main:
	li	$v0, 4
	la	$a0, dividendMsg
	syscall
	
	li	$v0, 5
	syscall
	add	$s0, $0, $v0
	
	li	$v0, 4
	la	$a0, divisorMsg
	syscall
	
	li	$v0, 5
	syscall
	add	$s1, $0, $v0
	
	add	$a0, $0, $s0
	add	$a1, $0, $s1
	
	jal	divide
	move	$s2, $v0
	
	li	$v0, 4
	la	$a0, quotientMsg
	syscall
	
	li	$v0, 1
	move	$a0, $s2
	syscall
	
	li	$v0, 4
	la	$a0, remainderMsg
	syscall
	
	li	$v0, 1
	move	$a0, $v1
	syscall
	
	li	$v0, 4
	la	$a0, contMsg
	syscall
	
	li	$v0, 5
	syscall
	beq	$v0, 1, main
	
	li	$v0, 10
	syscall
divide:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	bge	$a0, $a1, else
	addi	$v0, $0, 0
	add	$v1, $a0, $0
	addi	$sp, $sp, 4
	jr	$ra
else:
	sub	$a0, $a0, $a1
	jal	divide
	addi	$v0, $v0, 1
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
	.data
dividendMsg:	.asciiz "Enter a dividend: "
divisorMsg:	.asciiz "Enter a divisor: "
quotientMsg:	.asciiz "The quotient is: "
remainderMsg:	.asciiz	"\nThe remainder is: "
contMsg:	.asciiz "\nDo you want to coninue (1 for yes): "
