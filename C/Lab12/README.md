# Evaluative Lab 12

## Learning objectives

* Working with a user-defined datatype - structures
* Dynamically allocating arrays and structures

## Starting point

Use the shortcut Ctrl + Shift + V to open the README.md file in Preview mode.

The given starter code contains *skeletons* of three functions, the `main`, `allocate_memory`, and `get_input` functions. The structure definitions are also provided. It has 2 more functions that you need to write. It does not compile at this point as there are a few important points missing in the code. Make sure you go through the tasks given below in an orderly manner.

DO NOT CHANGE the `main` function or the structure definitions.

DO NOT use `break` or `continue`.

DO NOT SEEK HELP FROM ANYONE IN THE LAB, INCLUDING TAs.

# Tasks

## Task 0

First, rename the `.c` file to `YOURBITSID.c`.
Ensure that the YOURBITSID matches your ID on quanta, or in other words, the 'Campus ID' on the lab seating arrangement shared with you.

We will run a script to evaluate these automatically. If it fails, you will receive zero marks.

### Compilation instructions

You should know these by now, but here is a command to compile your program:

```sh
gcc YOURBITSID.c -o lab12
```

and a command to run the compiled program:

```sh
./lab12
```

## Task 1

Add appropriate header files in the program. Only use the header files taught in the course.
This program has 2 structures defined for an organization with employee details of their names and productivity. The max length of an employee's name is 49. The productivity is a positive integer ranging from 1 to 100 (both inclusive).

## Task 2

* Implement the function `allocate_memory` to match its description (`@brief`).
* Refer to the image provided in the folder for the memory allocation.
* The memory constraint is that main() can only save a single pointer to the organization. Rest all the pointers and the memory needed to store employee details will be allocated on the heap.

## Task 3
* Complete the `get_input` function to match its description (`@brief`).
* Refer to the image for a complete understanding of the memory allocation in the heap.
* After completing the function, check that you are able to take inputs from the user.
* You may write a `display()` to print all the inputs (fname and productivity). You should comment this out after you are done testing, else the autograder will fail.

## Task 4

* Implement the function `highest_prod` to match its description (`@brief`).
* Run your code, select the appropriate function and test with examples provided in the description.

## Task 4

* Implement the function `longest_name_alphabetically` to match its description (`@brief`).
* Run your code, select the appropriate function and test with examples provided in the description.

## Submit

We have provided some test cases with the code.
You can test your program against these by running the following command in the terminal:

```python
python3 autograder.py YOURBITSID.c Lab12-tests.json
```

We will run your submission against several test cases - you should test your code for other input combinations before submitting.

## Prepare Submission

1. First, make sure the .c file is renamed properly and works as expected.
2. Run the following command in the terminal to make the program to prepare submission an executable:

   ```sh
   chmod u+x prepare_submission
   ```

3. Execute that program to produce the submission file `YOURBITSID.tar.gz`:

   ```sh
   ./prepare_submission
   ```

4. Upload the created file to the appropriate assignment on <https://quanta.bits-goa.ac.in/>.
   Be sure to leave the 'Save As' option blank while uploading the your solution on quanta.