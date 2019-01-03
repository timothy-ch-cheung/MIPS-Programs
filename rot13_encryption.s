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
    li $a0 20
    li $v0 9 #sbrk
    syscall
    move $s1 $v0 # move the start heap address to $s1
    
main_loop:
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
    blez $v0 quit
    
    li $v0 4
    la $a0 processing
    syscall
    
    li $v0 4
    move $a0 $s0
    syscall
    
    la $a0 buffer
    move $a0 $s0
    move $a1 $s1
    jal rot_13
    
    li $v0 4
    la $a0 output
    syscall
    
    li $v0 4
    move $a0 $s1
    syscall
    
    li $v0 4
    la $a0 newline
    syscall
    
    j main_loop

### START VALIDATE STRING FUNCTION ###    
validate:
    lb $t1 ($a0)
    beq $t1 $zero valid_string
    
    subi $t2 $t1 64 # is the character ascii code >= 65
    blez $t2 invalid_string#AND
    subi $t2  $t1 123 # is the character ascii code <= 122 
    bgez $t2 invalid_string
    
    subi $t2  $t1 97 # is the character ascii code >= 97
    bgez $t2 continue#OR
    subi $t2 $t1 90 # is the character ascii code <= 90
    blez $t2 continue
    j invalid_string
continue:
    addi $a0 $a0 1 # next character
    j validate
    
valid_string:
    li $v0 1
    j return
    
invalid_string:
    li $v0 0
    j return
### END VALIDATE STRING FUNCTION ###

### START ROT_13 FUNCTION ###
rot_13:
    lb $t1 ($a0)
    beq $zero $t1 return
    subi $t2 $t1 90
    blez $t2 add_uppercase
    j add_lowercase
add_uppercase:
    subi $t2 $t1 77
    blez $t2 increment_13
    subi $t1 $t1 13
    j next_char
add_lowercase:
    subi $t2 $t1 109
    blez $t2 increment_13
    subi $t1 $t1 13
    j next_char
increment_13:
    addi $t1 $t1 13
next_char:
    sb $t1 ($a1)
    addi $a0 $a0 1
    addi $a1 $a1 1
    j rot_13
### END ROT_13 FUNCTION ###
    
return:
    jr $ra

quit:
    li $v0 4
    la $a0 end_program
    syscall 
    
    li $v0 10
    syscall

    