import os
import sys
import zipfile
def print_red(*args):
    red_text = "\033[91m" + " ".join(map(str, args)) + "\033[0m"
    print(red_text)
def print_green(*args):
    green_text = "\033[92m" + " ".join(map(str, args)) + "\033[0m"
    print(green_text)

def create_zip_with_file(zip_name, file_names):
    for file_name in file_names:
        if not os.path.exists(file_name):
            print_red("Error: File not found : " + file_name)
            sys.exit()
    with zipfile.ZipFile(zip_name, 'w') as zipf:
        for file_name in file_names:
            zipf.write(file_name, os.path.join("impl", file_name))
file_names = ["D_ff.v", "decoder4to16.v", "mux2to1_16bits.v", "mux32to2.v", "ram.v", "register8bit.v"]
zip_name = input("Enter your ID number (Eg: 2022A7PS9999G): ") + "_lab9.zip"
if len(zip_name) != 22:
    print_red("Invalid ID Number !!")
    sys.exit()
create_zip_with_file(zip_name, file_names)
print_green(f"Zip file '{zip_name}' created successfully in the impl folder. \nPlease submit the same on Quanta")
