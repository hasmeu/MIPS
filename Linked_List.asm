.data

# each node starts with no value and no next address
node1: .word 0, 0       
node2: .word 0, 0        
node3: .word 0, 0        

# head starts null
head:  .word 0           

.text
.globl main


main:
    # Insert values
    li $t0, 10           # $t0 = 10 (value to insert)
    la $a0, node1        # $a0 = address of node1
    jal insert           # Call insert(node1, 10) jal saves $ra as the location just after the jump.
    
    li $t0, 20           # $t0 = 20
    la $a0, node2        # $a0 = address of node2
    jal insert           # Call insert(node2, 20)
    
    li $t0, 30           # $t0 = 30
    la $a0, node3        # $a0 = address of node3
    jal insert           # Call insert(node3, 30)
    
    # Traverse the linked list
    jal traverse         
    
    # Delete the head node
    jal delete_head      
    
    # Traverse the linked list again
    jal traverse         
    
    li $v0, 10           # Exit
    syscall


# ($a0 = node address, $t0 = value)
insert:
    sw $t0, 0($a0)       # Store value in node
    lw $t1, head         # Load current head pointer
    sw $t1, 4($a0)       # Set node.next to head
    la $t1, head         # loads address of head into t1
    sw $a0, 0($t1)       # Point head to node 1. Saves address of node1 as value of head
    jr $ra               # Returns to the main and continues after the first jump

# Removes a node from the links, but does not deallocate it. Points head to the next node and loses access to the first node. 
delete_head:
    lw $t0, head         # Load current head pointer
    lw $t1, 4($t0)       # load head.next (head->next)
    sw $t1, head         # Update head pointer to head.next
    jr $ra               # Returns to the main and continues after jal

# Traverse function
traverse:
    lw $t0, head         # Load head pointer
traverse_loop:
    beq $t0, $zero, end_traverse  # if head pointer is null, all nodes have been printed.
    lw $t1, 0($t0)       # Load first node value
    li $v0, 1            # Print integer syscall
    move $a0, $t1
    syscall		  # print value
    la $a0, newline      # print the newline
    li $v0, 4            
    syscall
    lw $t0, 4($t0)       # Move to next node and loop printing
    j traverse_loop
end_traverse:
    jr $ra               # Return

.data
newline: .asciiz "\n"
