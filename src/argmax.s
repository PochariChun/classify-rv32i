.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0) # take current max `t0` = current max

    li t1, 0 # index
    li t2, 1 # counter  
loop_start:
    # TODO: Add your own implementation
    ble a1, t2, loop_end # <= 1, return index a0
    addi t3, a0, 4
    lw t4, 0(t3) # take the next element
    blt t4, t0, skip # if next element `t4` < current max, skip
    mv t0, t4 # update current max pointer
    mv t1, t2 # update index
skip:
    addi t2, t2, 1
    addi a0, a0, 4
    j loop_start

loop_end:
    mv a0, t1
    jr ra

handle_error:
    li a0, 36
    j exit
