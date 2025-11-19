#!/opt/homebrew/bin/bash
echo "Starting the program at $(date)"
echo "Running program $0 with $# arguments, pid $$"
for file in "$@"; do
	grep foobar "$file" > /dev/null 2> /dev/null
	if [[ $? -ne 0 ]]; then
		echo "File $file does not have foobar, adding one now"
		echo '#foobar' >> "$file"
	fi
done

