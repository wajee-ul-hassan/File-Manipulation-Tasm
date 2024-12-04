# File-Manipulation-Tasm
This project implements a simple file management system using Assembly Language (TASM). It allows users to perform the following operations on text files:

- **Copy**: Copies the contents of one file to others.
- **Append**: Appends the contents of one file to others.
- **Remove 'A'**: Removes all occurrences of the character 'A' from the files.

The program uses basic file handling techniques in DOS, including reading from and writing to files using interrupts.

## Features

- Copy file contents across multiple files.
- Append contents of one file to others.
- Remove the character 'A' from all files.
- Simple menu interface for user interaction.

## Requirements

- TASM (Turbo Assembler)
- DOSBox (to emulate DOS environment for running Assembly code)

## Usage

1. Compile the `fh.asm` file using TASM.
2. Run the program inside DOSBox.
3. Choose an action from the menu:
   - **1**: Copy contents of file1 to file2 and file3.
   - **2**: Append contents of file1 to file2 and file3.
   - **3**: Append contents of file3 to file1 and file2.
   - **4**: Remove all occurrences of the character 'A' from all files.

## How to Run

1. Ensure that you have **DOSBox** installed.
2. Compile the `fh.asm` file using **TASM**.
3. Launch the program within DOSBox by running the compiled executable.
4. Follow the on-screen instructions to perform file operations.

## Demo

You can watch a short demo of the project in action [here](link_to_video).

## License

This project is open-source and available under the MIT License.

## Acknowledgments

- Thanks to the contributors of TASM and DOSBox for providing the tools to run and test Assembly Language projects.

