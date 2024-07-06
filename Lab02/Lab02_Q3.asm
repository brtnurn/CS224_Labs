	.text
#---------------------- Lab Question --------------------------
main:
	li	$v0, 4
	la	$a0, arraySizeMsg
	syscall	
	
	li	$v0, 5
	syscall	
	add	$a0, $0, $v0
	
	li	$v0, 9
	syscall
	move	$a1, $a0
	move	$a0, $v0
	
	add	$s0, $0, $a0
	add	$s1, $0, $a1
	
	jal	monitor
	
	add	$s2, $0, $v0
	add	$s3, $0, $v1
	
	li	$v0, 4
	la	$a0, minmsg
	syscall
	
	li	$v0, 1
	add	$a0, $s2, $0
	syscall
	
	li	$v0, 4
	la	$a0, maxmsg
	syscall	
	
	li	$v0, 1
	add	$a0, $s3, $0
	syscall
	
	li	$v0, 4
	la	$a0, sortmsg
	syscall	
	
printArray:	
	beq	$s1, $0, ex
	li	$v0, 1
	lw	$a0, 0($s0)
	syscall
	li	$v0, 4
	la	$a0, comma
	syscall
	addi	$s0, $s0, 4
	addi	$s1, $s1, -1
	j	printArray
ex:	
	li	$v0, 10
	syscall
	
monitor:
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s0, 12($sp)
	sw	$s1, 8($sp)
	sw	$s2, 4($sp)
	sw	$s3, 0($sp)
	
	add	$s0, $0, $a0
	add	$s1, $0, $a1
	add	$s2, $0, $a0
input:	
	beq	$s1, $0, go
	li	$v0, 4
	la	$a0, inputmsg
	syscall
	li	$v0, 5
	syscall	
	sw	$v0, 0($s0)
	addi	$s0, $s0, 4
	addi	$s1, $s1, -1
	j	input
go:	
	add	$a0, $0, $s2
	jal	minMax
	#move	$s0, $v0
	#move	$s1, $v1
	
	add	$a0, $0, $s2
	jal	bubbleSort
	
	#add	$s0, $0, $s2
	#add	$s1, $0, $a1
	
	lw	$s3, 0($sp)
	lw	$s2, 4($sp)
	lw	$s1, 8($sp)
	lw	$s0, 12($sp)
	lw	$ra, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#--------------------------- Bubble Sort Part ---------------------------------
bubbleSort:
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)	
	sw	$s7, 0($sp)
	
	li	$s2, 0
outerLoop:	
	beq	$s2, $a1, return
	add	$s0, $0, $a0
	sub	$s1, $a1, $s2
innerLoop:	
	beq	$s1, 1, out
	lw	$s3, 0($s0)
	lw	$s4, 4($s0)
	bgt	$s3, $s4, swap
iter:	addi	$s1, $s1, -1
	addi	$s0, $s0, 4
	j	innerLoop
out:	
	addi	$s2, $s2, 1
	j	outerLoop
return:	
	lw	$s7, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	jr	$ra
swap:	
	add	$s7, $0, $s3
	sw	$s4, 0($s0)
	sw	$s7, 4($s0)
	j	iter
#--------------------------- Bubble Sort Part End -----------------------------	
#-------------------------- Min Max Part --------------------------------------	
minMax:	
	addi	$sp, $sp, -20		# save s registers
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	
	add	$s0, $0, $a0		# addr
	addi	$s1, $a1, -1		# size
	lw	$s2, 0($s0)		# min
	lw	$s3, 0($s0)		# max
	addi	$s0, $s0, 4
loop:	
	beq	$s1, $0, exit
	lw	$s4, 0($s0)
	blt	$s4, $s2, newmin
	bgt	$s4, $s3, newmax
next:	addi	$s0, $s0, 4
	addi	$s1, $s1, -1
	j	loop
newmin:	
	add	$s2, $0, $s4
	j	next
newmax:	
	add	$s3, $0, $s4
	j	next
exit:	
	add	$v0, $0, $s2
	add	$v1, $0, $s3
	lw	$s4, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#----------------------------- Min Max Part End --------------------------	
	.data
arraySizeMsg:	.asciiz	"Enter the array size: "
inputmsg:	.asciiz "Enter an integer to store: "
minmsg:		.asciiz "\nMin value in the array: "
maxmsg:		.asciiz "\nMax value in the array: "
sortmsg:	.asciiz "\nSorted array: "
comma:		.asciiz ", "
