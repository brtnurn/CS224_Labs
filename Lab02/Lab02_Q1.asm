	.text
#------------------ Preliminary Q1 ------------------
menu:	la	$a0, message	# hex string input msg
	li	$v0, 4
	syscall
	la	$a0, size	# hex string input (max 16 byte)
	li	$a1, 16
	li	$v0, 8
	syscall
	jal	conv		# go hex to decimal subprogram
	move	$t0, $v0	# save return value
	la	$a0, message2	# converted value msg
	li	$v0, 4
	syscall
	move	$a0, $t0
	li	$v0, 1		# print converted value
	syscall
	la	$a0, message3	# menu msg
	li	$v0, 4
	syscall
	la	$a0, size2	# input menu msg answer
	li	$a1, 2
	li	$v0, 8
	syscall
	lbu	$t1, 0($a0)
	beq	$t1, 89, menu	# if answer is yes
	li	$v0, 10		# if not, terminate program
	syscall
	
conv:	addi	$sp, $sp, -12	# stack allocation
	sw	$s0, 8($sp)	# holds bytes (digits) of hex string
	sw	$s1, 4($sp)	# holds converted digit
	sw	$s2, 0($sp)	# holds final value
	
loop:	lbu	$s0, 0($a0)	# load byte of hex string
	beq	$s0, 10, done	# if char == \n, end subprogram
	addi	$s1, $s0, -48	# find decimal number
	blt	$s1, 10, skip	# if digit is 1-9, skip
	addi	$s1, $s1, -7	# if not, convert letters a-f to decimal number
skip:	mul	$s2, $s2, 16	# << 1 befor adding
	add	$s2, $s2, $s1	# add converted digit to total
	addi	$a0, $a0, 1	# next byte
	j	loop
	
done:	move	$v0, $s2	# restore registers
	lw	$s2, 0($sp)
	lw	$s1, 4($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra		# go back to main program
	
	.data
message:	.asciiz "\nEnter a hexadecimal number: "
message2:	.asciiz "Decimal equivalent of your input: "
message3:	.asciiz "\nDo you want to continue? (Y for yes) "
size:		.space 16
size2:		.space 2
