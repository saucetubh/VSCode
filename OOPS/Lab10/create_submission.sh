#!/bin/bash

# Rigorous error checking
set -euo pipefail

# --- Configuration ---
# Add all the Java files that need to be part of the submission to this array.
# This makes it easy to update for future assignments.
readonly FILES_TO_SUBMIT=(
    "SavingsAccount.java"
)

# --- Main Script Logic ---

# 1. Check if a BITS ID was provided as a command-line argument.
if [ "$#" -ne 1 ]; then
    echo "Error: Missing BITS ID."
    echo "Usage: ./create_submission.sh <BITS_ID>"
    echo "Example: ./create_submission.sh 2024A7PS0001G"
    exit 1
fi

# 2. Assign the first argument to a variable for clarity.
BITS_ID="$1"
SUBMISSION_FILE="${BITS_ID}.zip"

# 3. Check if all the required submission files actually exist.
for file in "${FILES_TO_SUBMIT[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: Required file not found: '$file'"
        echo "Please make sure you are in the correct directory and the file exists."
        exit 1
    fi
done

# 4. If a previous submission zip exists, remove it to avoid confusion.
if [ -f "$SUBMISSION_FILE" ]; then
    rm "$SUBMISSION_FILE"
fi

# 5. Create the zip file containing only the specified Java files.
# The `"${FILES_TO_SUBMIT[@]}"` syntax handles file names with spaces correctly.
zip "$SUBMISSION_FILE" "${FILES_TO_SUBMIT[@]}"

# 6. Final confirmation message.
echo "✅ Submission file created successfully: $SUBMISSION_FILE"
