	.text
	.globl createLL
createLL:
	addi	$sp, $sp, -16
	sw	$s0, 12($sp)
	sw	$s1, 8($sp)
	sw	$s2, 4($sp)
	sw	$s3, 0($sp)
	
	add 	$s0, $0, $a0		# size
	addi	$s1, $0, 1		# counter
	li	$a0, 8
	li	$v0, 9
	syscall
	add	$s2, $v0, $0		# pointer to head
	add	$s3, $v0, $0		# pointer
	sw	$s1, 4($s2)
insert:
	beq	$s0, $s1, done
	addi	$s1, $s1, 1
	li	$a0, 8
	li	$v0, 9
	syscall
	sw	$v0, 0($s2)
	add	$s2, $0, $v0
	sw	$s1, 4($s2)
	j	insert
done:
	sw	$0, 0($s2)
	move	$v0, $s3

	lw	$s3, 0($sp)
	lw	$s2, 4($sp)
	lw	$s1, 8($sp)
	lw	$s0, 12($sp)
	addi	$sp, $sp, 16
	jr	$ra
	
	
	
