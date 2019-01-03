	.data
	.align 2

    buffer: .space 20
    input: .asciiz "Enter a string to encrypt/decrypt (enter non alphabet character to quit):\n"
    end_program: .asciiz "program quit"
    processing: .asciiz "processing: "
    output: .asciiz "\noutput: "
    newline: .asciiz "\n\n"
    
        .text
        
main:
    la $a0 input # output message
    li $v0 4
    syscall
    
    li $v0 8 # take user input string max characters 20
    la $a0 buffer
    li $a1 20
    move $s0 $a0
    syscall
    
    la $a0 buffer
    move $a0 $s0
    jal validate
    
    li $v0 4
    la $a0 processing
    syscall
    
    li $v0 4
    move $a0 $s0
    syscall
    
    li $v0 4
    la $a0 newline
    syscall
    
    j main
    
validate:
    lb $t1 ($a0)
    beq $t1 $zero return
    
    subi $t2 $t1 66 # is the character ascii code >= 65
    blez $t2 quit
    subi $t2  $t1 123 # is the character ascii code <= 122 
    bgez $t2 quit
    
    subi $t2  $t1 97 # is the character ascii code >= 97
    bgez $t2 continue
    subi $t2 $t1 90 # is the character ascii code <= 90
    blez $t2 continue
    j quit
continue:
    addi $a0 $a0 1 # next character
    j validate
    
return:
    jr $ra

quit:
    li $v0 4
    la $a0 end_program
    syscall 
    
    li $v0 10
    syscall

    