	.text
#------------------------- Prelim Q1 -----------------------
main:
	la	$a0, main
	la	$a1, done
	
	jal	count

	move	$s0, $v0
	
	li	$v0, 4
	la	$a0, msgMain
	syscall
	
	li	$v0, 1
	add	$a0, $s0, $0
	syscall
	
	la	$a0, count
	la	$a1, subDone
	
	jal	count
	
	move	$s1, $v0
	
	li	$v0, 4
	la	$a0, msgSub
	syscall
	
	li	$v0, 1
	add	$a0, $s1, $0
	syscall
done:
	li	$v0, 10
	syscall
	
count:
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	
	add	$s0, $a0, $0		# s0 = start addr
	
loop:	bgt	$s0, $a1, end
	lw	$s1, 0($s0)
	sll	$s3, $s1, 26		# funct
	srl	$s2, $s1, 26		# opcode
	beq	$s2, 0xd, inc
	beq	$s2, 0x23, inc
	beq	$s2, 0, checkFunct
next:	addi	$s0, $s0, 4
	j	loop
checkFunct:
	beq	$s3, 0x80000000, inc
	j	next
inc:
	addi	$s4, $s4, 1
	j	next	
end:	
	add	$v0, $s4, $0
	lw	$s4, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
subDone:
	jr	$ra
	
	.data
msg:		.asciiz "Total number of `add`, `ori, and `lw` instructions is: "
msgMain:	.asciiz "Number of `add`, `ori, and `lw` instructions in MAIN is: "
msgSub:		.asciiz "\nNumber of `add`, `ori, and `lw` instructions in SUBPROGRAM is: "