#!/opt/homebrew/bin/bash
gcc fizzbuzz.c -o fizzbuzz

if [ $? -ne 0 ]; then 
	echo "Compilation failed."
else 
	./fizzbuzz
fi

