# Lab 04

Welcome to your fourth lab.

## Starting point

Use the shortcut Ctrl + Shift + V to open the README.md file in Preview mode.

## Learning objectives

After completion of this lab, students will be able to

- Understand the basics of functions
- Understand the basic of Conditionals (if , else if , else)
- Understand the basics of operators
- Debug and do dry-runs by tracing

## Instructions

Make sure you follow these instructions carefully. 
This is an evaluative lab. You will NOT get any help from TAs or instructors.

### Rename the file to your BITS ID

You should see a C file: `Lab04.c`. The first thing you should do is rename it to your `BITSID.c`. For example, if your ID is 2023AXPS5678G, the file should be renamed to `2023AXPS5678G.c`.

To rename a file,

- right click on it in the explorer column on the left,
- click the rename option,
- type in the new name and hit enter.

## Running your C program

To compile your file:

```sh
gcc <BITSID>.c -o lab04
```

If your program has included <math.h>, use -lm flag for compilation
```sh
gcc <BITSID>.c -o lab04 -lm
```
If your program has no compile-time errors, run your program by:

```sh
./lab04
```

## Evaluative component

Look at the comments given in the code, and try to write a working code for the 3 functions given.

- Include all required header files
- Write valid parameters in the function headers by refering to the main()
- Write the logic for the functions
- Do NOT change the main()
- You are free to write any additional helper functions.

### Run against the given test cases

How do you know if your program is correct? We have some _test cases_ that do this for you.
Go to the terminal and run the command

```sh
python3 autograder.py <BITSID>.c Lab04-tests.json
```

> Your goal is to make _all_ test cases pass before you submit your lab.
> Try for other inputs as well. You solution will be evaluated with other test cases.

## Preparing the submission

1. First, make sure the .c file is renamed properly and works as expected (Your ID should end with a G).

2. Run the following command in the terminal to make the program to prepare submission an executable:

   ```sh
   chmod u+x prepare_submission
   ```

3. Execute that program to produce the submission file `YOURBITSID.tar.gz`:

   ```sh
   ./prepare_submission
   ```

4. Upload the created `YOURBITSID.tar.gz` file to the appropriate assignment on <https://quanta.bits-goa.ac.in/>.
   Be sure to leave the 'Save As' option blank while uploading the your solution on quanta.

   Also, check that the correct .tar.gz file has been uploaded before logging out from quanta. 
   Also, ensure that your submission is not in a draft form.