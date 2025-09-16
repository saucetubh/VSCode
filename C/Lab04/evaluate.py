import os
import sys
import autograder
import subprocess

# To use this script put below command in terminal
# python3 evaluate.py <test_case_json_file>.json
for root, dirs, files in os.walk(os.getcwd()):
    for file in files:
        if file.endswith(".c"):
            code_path = os.path.join(root, file)
            autograder.autoeval(code_path, sys.argv[1], "-i")
