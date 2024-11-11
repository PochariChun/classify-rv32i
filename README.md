# Assignment 2: Classify

TODO: Add your own descriptions here.
Update the top-level README.md file to document your work, explaining the functionality of the essential operations and detailing how you addressed and overcame the challenges. Of course, you must write in clear and expressive English.


## Absolute Value Conversion

This function provides a way to convert an integer into its absolute (non-negative) value by directly modifying the value in memory through pointer dereferencing. The function first checks if the integer is negative and, if so, negates it using `sub` instead of `neg` to ensure compatibility with the RV32I instruction set. The resulting non-negative value is stored back at the original memory address.
