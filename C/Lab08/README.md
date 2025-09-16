# Evaluative Lab 8 (05 Mar 2024)

## Learning objectives

* Working with loops
* Working with arrays
* Working with strings

## Starting point

The starter code compiles and executes but does not produce expected results at this point. Make sure you understand the given code.

Use the shortcut Ctrl + Shift + V to render the README.md file.

DO NOT CHANGE the helper functions or `main`.

DO NOT SEEK HELP FROM ANYONE, INCLUDING TAs.

## Tasks

### Task 0

First, rename the `.c` file to `YOURBITSID.c`.
Ensure that the YOURBITSID matches your ID on Quanta, which is also the 'Campus ID' on the lab seating arrangement shared with you.

You may delete any existing `.gz` files from the lab machine to avoid confusion when submitting.

#### Compilation instructions

You should know these by now, but here is a command to compile your program:

```sh
gcc YOURBITSID.c -o lab08
```

and the command to run the compiled program:

```sh
./lab08
```

### Task 1

Searching for specific information in the given data is a crucial computing operation. I am sure you search for something using software almost daily, be it reels on Instagram, music on Spotify, or assignments on your computer.

Binary search is a technique that makes searching significantly faster if the underlying data is sorted.
Here is the algorithm to search the `key` using binary search:

1. Find the midpoint of the range you are searching in. Compare the element at the midpoint against the `key`.
2. If that element matches the `key`, you have found the `key`. Stop.
3. If that element is smaller than the `key`, you only need to search in the half that's on the *right* of the midpoint.
4. If that element is greater than the `key`, you only need to search in the half that's on the *left* of the midpoint.

Illustrative examples:

1. Searching `3` in `[1, 3, 5, 7, 9]`
   * Midpoint is `5`. Since `5 > 3`, search only in the *left* half, `[1, 3]`.
   * Midpoing of `[1, 3]` is `1`. Since `1 < 3`, search only in the *right* half, `[3]`.
   * Midpoint of `[3]` is `3`. It matches; `key` is found!
2. Searching `6` in `[1, 3, 5, 7, 9]`
   * Midpoint is `5`. Since `5 < 6`, search only in the *right* half, `[7, 9]`.
   * Midpoint of `[7, 9]` is `7`. Since `7 > 6`, search only in the *left* half, `[]`.
   * Since `[]` is empty, `key` is not present!

Implement the function `binary_search` to match its description.

Do not use `break` or `continue` or any constructs not introduced in class.

Run your code, select the appropriate function, and test it.

### Task 2

Implement the function `count_vowels` to match its description.

Do not use `break` or `continue` or any constructs not introduced in class.

Run your code, select the appropriate function, and test it.

## Submit

We have provided some test cases with the code.
You can test your program against these by running the following command in the terminal:

```python
python3 autograder.py YOURBITSID.c Lab08-tests.json
```

We will run your submission against several other test cases - you should test your code for different input combinations before submitting.

### Prepare Submission

1. First, ensure the .c file is renamed correctly and works as expected.
2. Run the following command in the terminal to make the program to prepare submission an executable:

   ```sh
   chmod 700 prepare_submission
   ```

3. Execute that program to produce the submission file `YOURBITSID.tar.gz`:

   ```sh
   ./prepare_submission
   ```

4. Upload the created file to the appropriate assignment on <https://quanta.bits-goa.ac.in/>.
   Leave the 'Save As' option blank while uploading your solution on Quanta.
