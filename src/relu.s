.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1              
    blt a1, t0, error      # if a1 < 1, jump to error
    li t1, 0              # t1 = counter

loop_start:
    # TODO: Add your own implementation
    lw t2, 0(a0)
    bge t2, zero, loop_end
    sw zero, 0(a0)

loop_end:
    addi t1, t1, 1
    addi a0, a0, 4
    blt t1, a1, loop_start
    jr ra

error:
    li a0, 36          
    j exit          
