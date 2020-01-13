# Assembly-InOut-Management #
MASM Assembly program that implements low-level I/O procedures and macros, including a ReadVal and WriteVal procedure for unsigned integers, and getString and displayString macros Using Kip Irvine library for x86 processors.

## Design ##
I/O Management:
* Validate 10  user input integers using a readVal procedure and getString macro to prompt user for input, converts input from string to numeric, validates, and stored numbers in an array.
  * User inputs were accepted as strings and each character value confirmed as an integer. 
  * Reading from left to right, each new int addition included multiplication by 10 to make space for the next int in the ones column.
  * Both the length of the string and register overflow were checked to avoid numbers out of range for 32-bit registers.
* Input  is converted back to a string via the writeVal procedure and printed using the displayString macro.

Procedures:
* All parameters passed by address on the system stack and cleaned up at the conclusion of each procedure.
