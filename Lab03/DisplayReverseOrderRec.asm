	.text
	.globl printLL
main:
	li	$a0, 10
	jal	createLL
	move	$a0, $v0
	jal	printLL
	li	$v0, 10
	syscall
	
printLL:
	add	$s0, $a0, $0
	
rec:	addi	$sp, $sp, -8
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)
	bne	$s0, $0, else
	addi	$sp, $sp, 8
	jr	$ra
else:
	lw	$s0, 0($s0)
	jal	rec
	lw	$s0, 4($sp)
	
	li	$v0, 1
	lw	$a0, 4($s0)
	syscall
	
	li	$v0, 4
	la	$a0, comma
	syscall
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 8
	jr	$ra
	
	.data
comma:	.asciiz ", "