	.text
main:	
	la	$a0, matrixSize
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s6, $v0
	
	li	$s0, 4		# word size
	mult	$v0, $v0
	mflo	$s1		# nums
	mult	$s0, $s1
	mflo	$s2		# array size
	
	move	$a0, $s2
	li	$v0, 9
	syscall
	
	add	$s7, $v0, $0
	move	$a0, $s7
	move	$a1, $s1
	jal	fillMatrix
	
menu:
	la	$a0, option1
	li	$v0, 4
	syscall
	la	$a0, option2
	li	$v0, 4
	syscall
	la	$a0, option3
	li	$v0, 4
	syscall
	la	$a0, input
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	
	beq	$v0, 1, opt1
	beq	$v0, 2, opt2
	beq	$v0, 3, opt3
	j	end

opt1:
	move	$a0, $s7
	move	$a1, $s6
	jal	sub1
	j	menu
opt2:
	move	$a0, $s7
	move	$a1, $s2
	jal	sub2
	j	menu
opt3:
	move	$a0, $s7
	move	$a1, $s6
	jal	sub3
	j	menu
end:
	li	$v0, 10
	syscall
	
fillMatrix:
	addi	$sp, $sp, -12
	sw	$a0, 8($sp)
	sw	$a1, 4($sp)
	sw	$s2, 0($sp)
		
	li	$s2, 0
loop:
	beq	$a1, $s2, exit
	addi	$s2, $s2, 1
	sw	$s2, 0($a0)
	addi	$a0, $a0, 4
	j	loop
exit:
	lw	$s2, 0($sp)
	lw	$a1, 4($sp)
	lw	$a0, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra

sub1:
	addi	$sp, $sp, -28
	sw	$a0, 24($sp)
	sw	$a1, 20($sp)
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	
	move	$s4, $a0
	
	la	$a0, row
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s0, $v0
	
	la	$a0, col
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s1, $v0
	
	addi	$s1, $s1, -1
	mul	$s2, $s1, $a1
	mul	$s2, $s2, 4
	addi	$s0, $s0, -1
	mul	$s3, $s0, 4
	add	$s2, $s2, $s3
	add	$s4, $s4, $s2
	
	lw	$a0, 0($s4)
	li	$v0, 1
	syscall
	
	lw	$s4, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	lw	$a1, 20($sp)
	lw	$a0, 24($sp)
	addi	$sp, $sp, 28
	
	jr	$ra
	
sub2:
	addi	$sp, $sp, -20
	sw	$a0, 16($sp)
	sw	$a1, 12($sp)
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, 0($sp)
	
	li	$s0, 0		# i
	li	$s1, 0		# total
sub2loop:
	beq	$s0, $a1, sub2exit
	lw	$s2, 0($a0)
	add	$s1, $s1, $s2
	addi	$s0, $s0, 1
	addi	$a0, $a0, 4
	j	sub2loop
sub2exit:
	move	$a0, $s1
	li	$v0, 1
	syscall
	lw	$s2, 0($sp)
	lw	$s1, 4($sp)
	lw	$s0, 8($sp)
	lw	$a1, 12($sp)
	lw	$a0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
sub3:
	addi	$sp, $sp, -40
	sw	$a0, 36($sp)
	sw	$a1, 32($sp)
	sw	$s0, 28($sp)
	sw	$s1, 24($sp)
	sw	$s2, 20($sp)
	sw	$s3, 16($sp)
	sw	$s4, 12($sp)
	sw	$s5, 8($sp)
	sw	$s6, 4($sp)
	sw	$s7, 0($sp)
	
	li	$s0, 1		# row num
	li	$s1, 1		# col num
	li	$s2, 0		# row total
	li	$s3, 0		
	li	$s4, 0		# overall total
sub3outer:
sub3inner:
	move	$s7, $a0
	addi	$s5, $s1, -1
	mul	$s2, $s5, $a1
	mul	$s2, $s2, 4
	addi	$s6, $s0, -1
	mul	$s3, $s6, 4
	add	$s2, $s2, $s3
	add	$s7, $s7, $s2
	lw	$s2, 0($s7)
	add	$s4, $s4, $s2
	beq	$s1, $a1, iexit
	addi	$s1, $s1 1
	j	sub3inner
iexit:
	li	$s1, 1
	beq	$s0, $a1, oexit
	addi	$s0, $s0, 1
	j	sub3outer
oexit:
	move	$a0, $s4
	li	$v0, 1
	syscall
	
	lw	$s7, 0($sp)
	lw	$s6, 4($sp)
	lw	$s5, 8($sp)
	lw	$s4, 12($sp)
	lw	$s3, 16($sp)
	lw	$s2, 20($sp)
	lw	$s1, 24($sp)
	lw	$s0, 28($sp)
	lw	$a1, 32($sp)
	lw	$a0, 36($sp)
	addi	$sp, $sp, 40
	jr	$ra
	
	.data
matrixSize: 	.asciiz "Enter a matrix size: "
input:		.asciiz "Enter an option: "
option1:	.asciiz "\n1) Display desired elements of the matrix by specifying its row and column member\n"
option2:	.asciiz "2) Obtain summation of matrix elements column-major (column by column) summation\n"
option3:	.asciiz "3) Obtain summation of matrix elements row-major (row by row) summation\n"
row:		.asciiz "Enter a row number:"
col:		.asciiz "Enter a column number:"
