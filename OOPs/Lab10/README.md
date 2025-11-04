## Starting point
Use the shortcut Ctrl + Shift + V to open the README.md file in Preview mode.

## Given Test Cases
Uncomment and run Main.java to check your code on given test cases.
```sh
javac Main.java
```
```sh
java Main
```

You can change the inputs in Main.java to check for different test cases

## Hidden Test Cases
Run below commands to run hidden test cases:
```sh
javac *.java
```
```sh
java -cp .:TestRunner.jar TestRunner
```
It will show 7/7 test cases passed if correct.

## Submission
Add permission
```sh
chmod +x create_submission.sh
```
Run below command to create zip file
```sh
./create_submission.sh <YOUR_BITS_ID>
```
Example
```sh
./create_submission.sh 2024A7PS0001G
```
This will generate a file named <YOUR_BITS_ID>.zip (example: 2024A7PS0001G.zip). Submit it on Quanta.