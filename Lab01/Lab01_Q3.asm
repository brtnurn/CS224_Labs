	.text
#--------------- equation calculation ---------------
	la	$a0, message
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	add	$t0, $0, $v0	# int1
	
	la	$a0, message
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	add	$t1, $0, $v0	# int2
	
	mul	$t2, $t1, $t0
	add	$t2, $t2, $t1
	beq	$t0, $0, error
	beq	$t1, $0, error
	div	$t2, $t0
	mflo	$t2
	div	$t2, $t1
	mfhi	$t2
	
	li	$v0, 1
	move	$a0, $t2
	syscall
	
done:	li	$v0, 10
	syscall

error:	la	$a0, errormsg
	li	$v0, 4
	syscall
	j	done	
	
	.data
message:	.asciiz "Enter an integer: "
errormsg:		.asciiz "Div by 0"
