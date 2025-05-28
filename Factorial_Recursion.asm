.data
int:    .word 4  

.text

main:
    lw $t0, int        # load input value from memory into $t0
    move $a0, $t0      # pass $t0 as argument to factorial
    jal factorial      # call factorial function

    # Print 
    move $a0, $v0      # Move result from $v0 to $a0 for syscall
    li $v0, 1          #print integer syscall
    syscall

    li $v0, 10         # exit syscall
    syscall

factorial:
    #if n <= 1, return 1
    ble $a0, 1, base_case

    #  n * factorial(n - 1)
    addi $sp, $sp, -8  # allocate stack space
    sw $ra, 4($sp)     # save return address
    sw $a0, 0($sp)     # save n

    addi $a0, $a0, -1  # decrement n
    jal factorial      # recursive call to factorial
    lw $a0, 0($sp)     # restore n
    mul $v0, $a0, $v0  # multiply n * factorial(n - 1)

    
    lw $ra, 4($sp)     # restore return address
    addi $sp, $sp, 8   # deallocate stack space
    jr $ra             # return to caller

base_case:
    li $v0, 1          # base 1
    jr $ra             # return to rest of factorial
