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

### Operations

1. **Loop Implementation**: A loop is added to scan each element in the array, comparing it to the current maximum value in `t0`. If a new maximum is found, `t0` and `t1` are updated.
2. **Error Handling**: If the array length (`a1`) is less than 1, the function now terminates with an exit code of 36.

This update makes the function more robust by ensuring it only operates on non-empty arrays, correctly adjusts the index output, and efficiently identifies the maximum element’s index with a time complexity of O(n).

### Challenge 1: Conditional Value Setting without Additional Branches
During testing with `test_classify_1_silent`, the output was off by one index:  
```shell
Expected a0 to be 2 not: 3
```
 - **Solution**: I use **Offset Adjustment** to correct the output index, `addi t1, t1, -1` was added to adjust for a 1-based index offset, fixing an issue where `t1` returned an incorrect index. 

# RELU Function Implementation

This implementation provides a RELU (Rectified Linear Unit) operation for an integer array, setting each negative value to zero while preserving non-negative values. The function iterates through the array, applying this transformation element by element, which is particularly useful in neural network layers where non-linear activation functions are required.

## Operations

- **Loop through array elements**: The function uses a loop to access each element in the array sequentially.
- **Conditional Check**: A conditional check is performed on each element to determine if it is negative.
  - If an element is negative, it is set to zero.
  - If it is non-negative, the element remains unchanged.
- **Index and Pointer Adjustment**: The loop increments the array pointer and the element index for the next iteration.

## Challenges and Solutions

### Challenge 1: Conditional Value Setting without Additional Branches
- **Solution**: A straightforward comparison (`bge t2, zero, loop_end`) allows bypassing unnecessary operations on non-negative elements. This keeps the function optimized by only storing zero for negative values.

# Strided Dot Product Function

This implementation of the dot product function calculates the sum of products between two arrays, each accessed with a specified stride. The function iterates through each element in the arrays, multiplies corresponding elements, and accumulates the result. This is particularly useful for scenarios with non-contiguous data where strides specify the skip distance between elements.

## Operations

- **Stride Calculation**: The function calculates strides based on the input parameters and uses them to access elements in non-contiguous locations within each array.
- **Element-wise Multiplication and Accumulation**: Each iteration multiplies elements from the two arrays and adds the product to an accumulator.
- **Loop and Pointer Adjustment**: The loop increments array pointers according to the calculated strides, ensuring that only the specified elements are accessed.

## Challenges and Solutions

### Challenge 1: Pointer Increment Based on Strides
During testing with `test_dot_standard.s`, the output was off by one index:  
```shell
Expected a0 to be 285 not: 851982
```
- **Solution**: Used bitwise left shift (`slli`) to multiply stride values by 4, aligning with 32-bit integer access. This approach simplified pointer adjustment, ensuring correct navigation through non-contiguous data segments.

# Classify

This implementation introduces a custom multiplication function in the `classify` operation, replacing the default `mul` instruction. The custom `mult` function uses binary shifting and addition to perform integer multiplication, which avoids reliance on the built-in `mul` instruction.

## Essential Operations

- **Binary Decomposition**: The function iterates through each bit in the multiplier (`t1`). For each set bit, the multiplicand (`t0`) is shifted by the bit's position and added to the accumulator.
- **Bitwise Shifting and Accumulation**: The multiplicand is left-shifted, and the multiplier is right-shifted through each iteration to access individual bits. When a bit is set, the shifted multiplicand is added to the result.
- **Loop and Condition Check**: The loop increments a counter and checks each bit in the multiplier, stopping when all bits have been processed.

## Challenges and Solutions

### Challenge 1: Avoiding the 'mul' Instruction
- **Solution**: Designed a loop that decomposes the multiplication into shifts and additions, following the principles of binary multiplication. This removed the dependency on the `mul` instruction.

### Challenge 2: Efficient Bitwise Manipulation
- **Solution**: Used bitwise `AND` to check bits in the multiplier and bitwise shifts (`sll` and `srli`) for bit manipulation. This approach ensures efficient processing while remaining assembly-compatible.

# Matrix Multiplication Implementation

This implementation performs matrix multiplication, calculating the product of two input matrices and storing the result in an output matrix. It uses a combination of loops and the `dot` function for efficient element-wise computation.

## Functionality

- **Input Matrices**:
  - `M0` (Matrix A): A matrix with dimensions `rows0 × cols0`.
  - `M1` (Matrix B): A matrix with dimensions `rows1 × cols1`.

- **Output Matrix**:
  - `D` (Result): A matrix with dimensions `rows0 × cols1`.

### Key Steps

1. **Validation**: Ensures that input dimensions are positive and compatible for multiplication (`M0_cols = M1_rows`). Exits with error code 38 for invalid inputs.
2. **Outer Loop**: Iterates through each row of Matrix A.
3. **Inner Loop**: Iterates through each column of Matrix B.
4. **Dot Product**: Calculates the dot product of a row from Matrix A and a column from Matrix B using the `dot` function.
5. **Result Storage**: Stores the result of the dot product into the appropriate element in the output matrix.

## Challenges and Solutions

### Challenge 1: Stride-Based Memory Access
- **Solution**: Used stride calculations to access next element of MatrixB elements in memory.

### Challenge 2: Dimension Compatibility Validation
- **Solution**: Included pre-checks for matrix dimensions before processing, ensuring only valid inputs proceed to the computation stage.

## Usage

The `matmul` function is suitable for general-purpose matrix multiplication, supporting cases where input matrices have non-square dimensions or require stride-based memory management.

### Arguments

1. **Matrix A**:
   - Address: `a0`
   - Rows: `a1`
   - Columns: `a2`
2. **Matrix B**:
   - Address: `a3`
   - Rows: `a4`
   - Columns
