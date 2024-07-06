	.text
#------------------ Preliminary Q2 ------------------	
main:	li	$v0, 4
	la	$a0, inputmsg
	syscall				# input msg
	
	li	$v0, 5
	syscall				# take input in decimal numbers
	add	$t0, $0, $v0
	
	li	$v0, 4
	la	$a0, convmsg
	syscall

	li	$v0, 34
	add	$a0, $0, $t0
	syscall				# print decimal input in hexadecimal numbers
	
	jal	subp			# go to subprogram to invert bytes
	
	add	$t7, $0, $v0
	
	li	$v0, 4
	la	$a0, invertedmsg
	syscall
	
	li	$v0, 34
	add	$a0, $0, $t7
	syscall				# print inverted hex integer
	
	li	$v0, 4
	la	$a0, cont
	syscall
	
ask:	li	$v0, 5			# continue to program?
	syscall
	add	$t1, $0, $v0
	
	beq	$t1, 0, exit
	beq	$t1, 1, main
	j	ask

exit:	li	$v0, 10			# terminate program
	syscall

subp:	addi	$sp, $sp, -12		# save s registers
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, 0($sp)
	
loop:	beq	$s0, 4, done		# loop to invert bytes
	andi	$s1, $a0, 0xff
	mul	$s2, $s2, 256
	add	$s2, $s2, $s1
	srl	$a0, $a0, 8
	addi	$s0, $s0, 1
	j	loop
	
done:	add	$v0, $0, $s2		# save inverted hexadecimal number and restore s registers
	lw	$s2, 0($sp)
	lw	$s1, 4($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra			# go back to main program

	.data

inputmsg:	.asciiz "Enter a decimal number: "
convmsg:	.asciiz	"Input converted to hexadecimal number is: "
invertedmsg:	.asciiz "\nInverted hexadecimal number is: "
cont:		.asciiz "\nDo you want to continue? (1 for yes, 0 for no): "