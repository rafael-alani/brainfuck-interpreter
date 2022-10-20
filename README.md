# Brainfuck

 - main.s:
    This file contains the main function.
    It reads a file from a command line argument and passes it to your brainfuck implementation.

 - read_file.s:
    Holds a subroutine for reading the contents of a file.
    This subroutine is used by the main function in main.s.

 - brainfuck.s:
    Main logic implementation, the aproach I have used is simulating the memory and looping over each instruction thaking the apropriate action.

No major optimizations has been implemented, as the whole aproach such be redesigned.

Feel free to have a look at the different files, but keep in mind that all you need to do is:

  1. Run `make`
  2. Run `./brainfuck examples/<filename>`
