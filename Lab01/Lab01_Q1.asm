	.text
# ------------- Preliminary Work -------------

	la	$t0, array	# array pointer
	lw	$t1, arraySize	# array size
	li	$t2, 0		# equal to N counter
	li	$t3, 0		# less than N counter
	li	$t4, 0		# greater than N counter
	li	$t5, 0		# divisible by N counter
	la 	$a0, msg	# proper input msg
	li 	$v0, 4
	syscall
	li 	$v0, 5		# int read for syscall
	syscall
	add	$s4, $s4, $v0
	add	$s5, $s5, $s4
input:	
	beq 	$s4, $0, init	# while arraySize != 0
	la 	$a0, message1	# proper input msg
	li 	$v0, 4
	syscall
	li 	$v0, 5		# int read for syscall
	syscall
	sw 	$v0, 0($t0)	# save input to array
	addi 	$t0, $t0, 4	# goes to next element
	addi 	$s4, $s4, -1	# arraySize -= 1
	j 	input

init:	la	$t0, array	# goes back to beginning of the array
	add	$s4, $s4, $s5	# set the size to 20 again
	la 	$a0, message2
	li 	$v0, 4
	syscall
	li 	$v0, 5		# input integer N
	syscall
	add	$a1, $0, $v0	# save the int N
	
calc:	beq	$s4, $0, menu	# while arraySize != 0
	lw	$a2, 0($t0)
	jal	mod		# check if element div by N
	beq	$a2, $a1, eq
	blt	$a2, $a1, lt
	bgt	$a2, $a1, gt

mod:	div 	$a2, $a1
	mfhi	$t8		# get remainder
	beq	$t8, $0, divby
	jr	$ra		# go back to calc to check eq, lt or gt

divby:	addi	$t5, $t5, 1	# div by ct += 1
	jr	$ra		# go back to calc to check eq, lt or gt
	
eq:	addi 	$t2, $t2, 1	# eq ct += 1
	j	next
	
lt:	addi 	$t3, $t3, 1	# lt ct += 1
	j	next
	
gt:	addi 	$t4, $t4, 1	# gt ct += 1
	j	next

next:	addi 	$t0, $t0, 4	# array addr += 4
	addi 	$s4, $s4, -1	# arraySize -= 1
	j	calc

menu:	la 	$a0, menuMessage2
	li 	$v0, 4
	syscall
	la 	$a0, menuMessage1
	syscall
	li 	$v0, 5		# input integer N
	syscall
	add	$s0, $0, $v0
	beq	$s0, 0, done
	beq	$s0, 1, eqp
	beq	$s0, 2, ltp
	beq	$s0, 3, gtp
	beq	$s0, 4, divbyp	

# print number of ints eq to N
eqp:	la 	$a0, message3
	li 	$v0, 4
	syscall
	li	$v0, 1
	move	$a0, $t2
	syscall
	j	menu
# print number of ints lt N
ltp:	la 	$a0, message4
	li 	$v0, 4
	syscall
	li	$v0, 1
	move	$a0, $t3
	syscall
	j	menu
# print number of ints gt N
gtp:	la 	$a0, message5
	li 	$v0, 4
	syscall
	li	$v0, 1
	move	$a0, $t4
	syscall
	j	menu
# print number of ints div by N	
divbyp:	la 	$a0, message6
	li 	$v0, 4
	syscall
	li	$v0, 1
	move	$a0, $t5
	syscall	
	j	menu
# terminate program	
done:	li	$v0, 10	
	syscall	
	
	.data
# Allocate 80 bytes = space enough to hold 20 integers each one is one word
array: 		.space 80 	
arraySize:	.word 20
message1: 	.asciiz "Enter an integer to store: "
message2: 	.asciiz "Enter an integer: "
message3: 	.asciiz "Number of integers equal to N is "
message4: 	.asciiz "\nNumber of integers less than N is "
message5: 	.asciiz "\nNumber of integers greater than N is "
message6: 	.asciiz "\nNumber of integers divisible by N is "
menuMessage1:	.asciiz "\nEnter an option: "
menuMessage2:	.asciiz "\n1) Find the number of array members equal to N.\n2) Find the number of array members less than N.\n3) Find the number of array members greater than N.\n4) Find the number of elements evenly divisible by N."
msg:		.asciiz "How many integers you want to input: "