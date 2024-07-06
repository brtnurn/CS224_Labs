	.text
	
main:
	li	$a0, 10
	jal	createLL
	move	$a0, $v0
	jal	copyLL
	move	$a0, $v0
	jal	printLL
	li	$v0, 10
	syscall

copyLL:
	addi	$sp, $sp, -16
	sw	$s0, 12($sp)
	sw	$s1, 8($sp)
	sw	$s2, 4($sp)
	sw	$s3, 0($sp)
	
	add	$s0, $a0, $0		# original ll
	li	$a0, 8
	li	$v0, 9
	syscall
	add	$s1, $v0, $0		# copy ll
	add	$s3, $v0, $0 
	
copy:	lw	$s2, 4($s0)
	sw	$s2, 4($s1)
	lw	$s0, 0($s0)
	beq	$s0, $0, doneCopy
	li	$a0, 8
	li	$v0, 9
	syscall
	sw	$v0, 0($s1)
	move	$s1, $v0
	j	copy
doneCopy:
	move	$v0, $s3
	addi	$sp, $sp, 16
	lw	$s3, 0($sp)
	lw	$s2, 4($sp)
	lw	$s1, 8($sp)
	lw	$s0, 12($sp)
	jr	$ra