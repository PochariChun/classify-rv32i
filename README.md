# Assignment 2: Classify

TODO: Add your own descriptions here.
Update the top-level README.md file to document your work, explaining the functionality of the essential operations and detailing how you addressed and overcame the challenges. Of course, you must write in clear and expressive English.




# Function: `abs` (Absolute Value)

This function provides a way to convert an integer into its absolute (non-negative) value by directly modifying the value in memory through pointer dereferencing. 
The function first checks if the integer is negative and, if so, negates it using `sub` instead of `neg` to ensure compatibility with the RV32I instruction set. The resulting non-negative value is stored back at the original memory address.




# Function: `argmax`

The `argmax` function scans an integer array to find the maximum value and returns the index of its first occurrence. The implementation is optimized for correctness and performance by leveraging a loop structure with conditional checks.

## Key Features

- **Input**:
  - An integer array with at least one element.
- **Output**:
  - The 0-based index of the first occurrence of the maximum element.
- **Error Handling**:
  - Terminates with error code 36 if the array length is less than 1.

## Changes and Improvements

### Original Problem
The original implementation contained the following issues:
1. **Off-by-One Error**: The index calculation incorrectly incremented the index during the loop, leading to an incorrect return value.
2. **Incorrect Skip Logic**: No provision existed to skip updating the maximum when the current element was smaller.

### Solution
- **Index Correction**: Fixed the loop logic to track the current maximum's index accurately without the off-by-one error.
```
   li t1, 0 # index
   li t2, 1 # counter  
```
- **Skip Unnecessary Updates**: Added conditional logic to skip updates when the current element is less than the current maximum.
```
    blt t4, t0, skip # if next element `t4` < current max, skip
    mv t0, t4 # update current max pointer
    mv t1, t2 # update index
skip:
```

## Loop Logic

### Key Steps
1. **Initialize Loop**:
   - Compare the current index with the array length.
   - Exit the loop when all elements have been processed.
2. **Evaluate Element**:
   - Load the current element from the array.
   - Compare it with the current maximum.
   - Skip update operations if the element is smaller than the current maximum.
3. **Update Maximum and Index**:
   - If the current element is greater, update the maximum value and its index.
4. **Increment and Continue**:
   - Move to the next element and repeat the loop.







# Function: `RELU`

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







# Function: Strided `Dot`

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






# Function: `Classify`

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








# Function: `matmul` (Matrix Multiplication)

The `matmul` function performs matrix multiplication, calculating the product of two input matrices and storing the result in an output matrix. It uses a combination of loops and the `dot` function for efficient element-wise computation.


## Key Features

- **Input Matrices**:
  - Matrix A (`M0`): Dimensions `rows0 × cols0`.
  - Matrix B (`M1`): Dimensions `rows1 × cols1`.
- **Output Matrix**:
  - Matrix C (`D`): Dimensions `rows0 × cols1`.

### Validation and Operations
1. **Validation**:
   - Ensures positive dimensions for both matrices.
   - Verifies multiplication compatibility (`cols0 == rows1`).
   - Exits with error code 38 for invalid inputs.

2. **Matrix Multiplication**:
   - Iterates over rows of Matrix A and columns of Matrix B.
   - Computes the dot product for corresponding row-column pairs using a nested loop structure.
   - Stores the resulting values in the output matrix.

## Problem and Solution

### Original Problem
- **Issue**: The stack pointer (`sp`) was not correctly restored in the function's epilogue, leading to a mismatch error.
- **Error Details**:
  - Venus error: `Save register sp not correctly restored before return`.
  - Expected `sp`: `0x7FFFFFDC`, Actual: `0x7FFFFFD8`.
- **Cause**: The original epilogue failed to account for all saved registers, resulting in an off-by-4 error during stack restoration.

### Solution Fix
The epilogue ensures proper cleanup before returning from the function:
- Restores saved registers (`ra`, `s0-s5`) from the stack.
- Adjusts the stack pointer (`sp`) back to its original position.

## Usage

### Function Prototype
```assembly
matmul:
    # Arguments:
    #   a0: Address of Matrix A
    #   a1: Number of rows in Matrix A
    #   a2: Number of columns in Matrix A
    #   a3: Address of Matrix B
    #   a4: Number of rows in Matrix B
    #   a5: Number of columns in Matrix B
    #   a6: Address for storing Matrix C (result)
```







# Function: `read_matrix` (Binary Matrix File Reader)

The `read_matrix` function loads a matrix from a binary file into dynamically allocated memory. The matrix dimensions are read from the file's header, and the data is stored in row-major order. This function now incorporates a custom `mult` implementation to replace the `mul` instruction for environments where the `mul` operation is unavailable.

### Key Operations
1. **File Operations**:
   - Open file (`fopen`) and handle errors for file access.
   - Read the header to obtain matrix dimensions.
   - Read the matrix data and validate the read operation.
   - Close the file after loading.

2. **Dynamic Memory Allocation**:
   - Allocate memory for the matrix based on the calculated size.
   - Handle memory allocation errors.

3. **Matrix Dimension Multiplication**:
   - Replaced the `mul` instruction with a custom `mult` function that performs binary multiplication using shifts and additions.

4. **Error Handling**:
   - Exit codes for various errors:
     - `26`: Memory allocation failure.
     - `27`: File access error.
     - `28`: File closure error.
     - `29`: Data read error.







# Function: `write_matrix` (Binary Matrix File Writer)

The `write_matrix` function writes an integer matrix to a binary file. The function formats the file with a header containing the matrix dimensions, followed by the matrix data in row-major order. This implementation incorporates a custom `mult` function to replace the `mul` instruction for environments lacking native multiplication support.

### Key Steps
1. **File Operations**:
   - Opens the binary file for writing (`fopen`).
   - Writes the header containing the number of rows and columns.
   - Writes the matrix elements to the file in row-major order.
   - Closes the file after writing.

2. **Matrix Size Calculation**:
   - Replaced the `mul` instruction with the `mult` function to calculate the total number of elements in the matrix (`rows × columns`).

3. **Error Handling**:
   - Exit codes for various errors:
     - `27`: File access error (`fopen`).
     - `28`: File closure error (`fclose`).
     - `30`: File write error (`fwrite`).

## `mult` Function

This implementation aligning with the improvements made in `read_matrix`.








# Function: `mult` (Custom Multiplication Function)

This implementation aligns with the improvements made in `read_matrix`, `write_matrix`, and `classify`.  
The `mult` function provides a custom implementation of binary multiplication using bitwise operations and additions. This refactored version is parameter-free, relying on the calling function to set up the necessary registers (prologue) and restore them after usage (epilogue).

## Functionality

### Key Operations
1. **Binary Multiplication**:
   - Decomposes the multiplier into bits and performs bitwise shifts and additions to calculate the product.
2. **Prologue and Epilogue**:
   - The calling function is responsible for saving and restoring necessary registers before and after calling `mult`.

### Usage Examples

#### In `classify.s`
```assembly
# Prologue: Prepare operands t0 (multiplicand) and t1 (multiplier)
# mul a1, t0, t1 
jal mult
mv a1, t2
```
#### In `write_matrix.s`
```
# Prologue: Prepare operands s2 (multiplicand) and s3 (multiplier)
jal mult
# Epilogue: Restore registers and store the result
lw s2, 24(sp)
lw s3, 28(sp)
mv s4, t0
```
#### In `read_matrix.s`
```
# Prologue: Prepare operands t1 (multiplicand) and t2 (multiplier)
jal mult
# Epilogue: Store the result in s1
mv s1, t0
```