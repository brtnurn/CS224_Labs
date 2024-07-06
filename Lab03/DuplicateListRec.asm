	.text
	
main:
	li	$a0, 10
	jal	createLL
	move	$a0, $v0
	jal	dupLL
	move	$a0, $v0
	jal	printLL
	li	$v0, 10
	syscall
	

dupLL:
	add	$s0, $a0, $0
	li	$a0, 8
	li	$v0, 9
	syscall
	add	$s1, $v0, $0
dupLLRec:	
	addi	$sp, $sp, -12
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$ra, 0($sp)
	bne	$s0, $0, dupElse
	sw	$0, 0($s1)
	addi	$sp, $sp, 12
	jr	$ra
dupElse:
	lw	$s0, 0($s0)
	beq	$s0, $0, skip
	li	$a0, 8
	li	$v0, 9
	syscall
	sw	$v0, 0($s1)
	move	$s1, $v0
skip:	jal	dupLLRec
	
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$s2, 4($s0)
	sw	$s2, 4($s1)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 12
	add	$v0, $0, $s1
	jr	$ra