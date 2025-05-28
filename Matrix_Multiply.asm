.data
    #matrix dimensions
    N:      .word   4       
    
    #sample matrices
    matrixA: .word   1, 2, 3, 4
             .word   5, 6, 7, 8
             .word   9, 10, 11, 12
             .word   13, 14, 15, 16
    
    matrixB: .word   16, 15, 14, 13
             .word   12, 11, 10, 9
             .word   8, 7, 6, 5
             .word   4, 3, 2, 1
    
    matrixC: .space  64     # result matrix size
    

.text

main:

    #load dimensions
    lw $s0, N          #$s0 = N
    
    
    #outer loop (rows of A)
    #initialize i
    li $t0, 0          
outer_loop:
    beq $t0, $s0, done #if i = N, exit checks if outer loop is done

    #middle loop (columns of B)
    #initialize j
    li $t1, 0          
middle_loop:
    beq $t1, $s0, next_row #if j = N, go to next row check if middle loop is done.

    #dot product loop
    #initialize k 
    li $t2, 0          
    li $v1, 0          # Reset result for v1. needs to reset for each beginning of inner loop
inner_loop:
    beq $t2, $s0, store_result # if k = N, store result. Check if inner loop is done

    # A [i*N + k]
    # calculate address of A[i][k]
    mul $t3, $t0, $s0  
    add $t3, $t3, $t2
    sll $t3, $t3, 2    # same as multiply by 4. shifts two bits to the left. a shift to the left is the same as multiplying by 2
    la $t4, matrixA
    add $t4, $t4, $t3
    lw $t5, ($t4)      # loads number at address into temporary 5

    # B[k*N + j]
    #calculate address of B[k][j]
    mul $t3, $t2, $s0	# multiply to get the column
    add $t3, $t3, $t1	# add to get the exact element location
    sll $t3, $t3, 2    # same as multiply by 4. accounts for 4 bytes per number shifts two bits to the left. a shift to the left is the same as multiplying by 2
    la $t4, matrixB
    add $t4, $t4, $t3
    lw $t6, ($t4)      # loads number at address into temporary 6

    # Multiply and add to v1
    mul $t7, $t5, $t6
    add $v1, $v1, $t7

    # Increment k
    addi $t2, $t2, 1
    j inner_loop

store_result:
    # C[i*N + j]
    # calculate address of C[i][j]
    mul $t3, $t0, $s0
    add $t3, $t3, $t1
    sll $t3, $t3, 2    # same as multiply by 4. shifts two bits to the left. a shift to the left is the same as multiplying by 2
    la $t4, matrixC	# load address of matrixC
    add $t4, $t4, $t3
    sw $v1, ($t4)      # store result in matrixC

    # increment j
    addi $t1, $t1, 1
    j middle_loop

next_row:
    #increment i
    addi $t0, $t0, 1
    j outer_loop

done:
    #exits
    li $v0, 10
    syscall
