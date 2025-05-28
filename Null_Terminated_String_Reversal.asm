.data
string: .asciiz "Hello"  # by default a null terminated string

.text

main:
    # Loads address of the string into register $a0
    la   $a0, string

    
    move  $t0, $a0      # $t0 points to the beginning of the string
    li    $t1, 0        # $t1 holds count of length
find_length:
    lb    $t2, 0($t0)   # Load character at location of $t0
    beq   $t2, $zero, done_length  # If null terminator, stop
    addi  $t0, $t0, 1    # Move to the next character by increasing value of $t0 address
    addi  $t1, $t1, 1    # Increment string length count
    j     find_length
done_length:
    
    #  $t0 is the start and $t1 is the end index for swapping
    la   $t0, string     # $t0 points to the beginning of the string
    add  $t1, $t0, $t1   # $t1 points to the null terminator
    addi $t1, $t1, -1    # Move $t1 to point at the last character.

reverse_loop:
    # Check if t0 has crossed t1
    bge  $t0, $t1, done_reverse

    # Loads characters from both ends
    lb   $t2, 0($t0)     # Loads character from the start
    lb   $t3, 0($t1)     # Loads character from the end

    # Swap 
    sb   $t2, 0($t1)     # store t2 at location of t1
    sb   $t3, 0($t0)     # Store t3 at location of t0

    # Move the pointers toward each other
    addi $t0, $t0, 1     # Increment $t0.  moves to the right
    addi $t1, $t1, -1    # Decrement $t1. moves to the left
    j    reverse_loop

done_reverse:
    # Print the reversed string (MIPS syscall 4)
    li   $v0, 4           # Syscall code for printing a string
    la   $a0, string      # Load address of the reversed string
    syscall               # Make the syscall to print the string

    # Exit the program (MIPS syscall 10)
    li   $v0, 10          # Syscall code for exit
    syscall               # Make the syscall to exit the program
