# Assembly-Avg-And-Sum #
This program uses MASM assembly language to receive 10 user input integers, validate the input, and return their sum and avaerage.

## Design ##
Error validation: 
* User inputs were accepted as strings and each character value confirmed as an integer. 
* Reading from left to right, each new int addition included multiplication by 10 to make space for the next int in the ones column.
* Both the length of the string and register overflow were checked to avoid numbers out of range for 32-bit registers.
Number Array:
* Once confirmed, each number was stored for arithmetic by manual array management.
