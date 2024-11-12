# Assignment 2: Classify

TODO: Add your own descriptions here.
Update the top-level README.md file to document your work, explaining the functionality of the essential operations and detailing how you addressed and overcame the challenges. Of course, you must write in clear and expressive English.


# Absolute (abs) Function

This function provides a way to convert an integer into its absolute (non-negative) value by directly modifying the value in memory through pointer dereferencing. 
The function first checks if the integer is negative and, if so, negates it using `sub` instead of `neg` to ensure compatibility with the RV32I instruction set. The resulting non-negative value is stored back at the original memory address.


# argmax Function

The `argmax` function finds the index of the first occurrence of the maximum value in an integer array. If multiple elements share this maximum value, it returns the smallest index. If the array length is less than 1, the function exits with code 36.

### Key Registers

- **t0**: Stores the current maximum value as the function iterates through the array.
- **t1**: Holds the index of the first occurrence of the maximum value.
- **t2**: Serves as a loop counter to traverse the array elements.

### Key Changes

1. **Loop Implementation**: A loop is added to scan each element in the array, comparing it to the current maximum value in `t0`. If a new maximum is found, `t0` and `t1` are updated.
2. **Error Handling**: If the array length (`a1`) is less than 1, the function now terminates with an exit code of 36.
3. **Offset Adjustment**: To correct the output index, `addi t1, t1, -1` was added to adjust for a 1-based index offset, fixing an issue where `t1` returned an incorrect index. 

This update makes the function more robust by ensuring it only operates on non-empty arrays, correctly adjusts the index output, and efficiently identifies the maximum element’s index with a time complexity of O(n).

**Example Issue and Fix:**
During testing with `venus.jar`, the output was off by one index:  
```shell
Expected a0 to be 2 not: 3


# RELU Function Implementation

## Overview

This implementation provides a RELU (Rectified Linear Unit) operation for an integer array, setting each negative value to zero while preserving non-negative values. The function iterates through the array, applying this transformation element by element, which is particularly useful in neural network layers where non-linear activation functions are required.

## Essential Operations

- **Loop through array elements**: The function uses a loop to access each element in the array sequentially.
- **Conditional Check**: A conditional check is performed on each element to determine if it is negative.
  - If an element is negative, it is set to zero.
  - If it is non-negative, the element remains unchanged.
- **Index and Pointer Adjustment**: The loop increments the array pointer and the element index for the next iteration.

## Challenges and Solutions

### Challenge 1: Conditional Value Setting without Additional Branches
- **Solution**: A straightforward comparison (`bge t2, zero, loop_end`) allows bypassing unnecessary operations on non-negative elements. This keeps the function optimized by only storing zero for negative values.

