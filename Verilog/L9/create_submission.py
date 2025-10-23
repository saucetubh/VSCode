DATA_URL = "https://gist.githubusercontent.com/khrj/f7c983571755c5e73f2b6676d9179040/raw/50ec98a3278204124d57288c2ece9783ed018be3/student_data.csv"


from pathlib import Path

import urllib.request
import csv
import io
import re
import shutil

bits_id = input("Enter your ID: ").upper()
zip_name = f"{bits_id}_Lab9.zip"
png_name = f"{bits_id}_Lab9.png"

try:
    with urllib.request.urlopen(DATA_URL) as response:
        if response.status != 200:
            raise Exception("Failed to fetch data")

        csv_file = io.StringIO(response.read().decode("utf-8"))
        reader = csv.DictReader(csv_file)

        name = None

        for row in reader:
            if row["ID"] == bits_id:
                name = row["Name"]
except:
    print("WARN: Failed to validate ID from SWD, using primitive validation")
    if re.fullmatch(r"202[0-9][a-zA-Z0-9]{4}[0-9]{4}G", bits_id):
        name = bits_id
    else:
        print("ERROR: ID not of the format 202XXXXXXXXXG.")
        exit(1)

if not name:
    print("ERROR: ID not found in SWD data. Make sure your ID is of the format 202XXXXXXXXXG.")
    exit(1)

submission_dir = Path("zip_submission")
png_dir = Path(png_name)

if not png_dir.exists():
    print(f"ERROR: Could not find your PNG file '{png_name}' in the current directory.")
    exit(1)

shutil.rmtree(submission_dir, ignore_errors=True)
submission_dir.mkdir(parents=True, exist_ok=True)

shutil.copytree("modules", submission_dir.joinpath("modules"), dirs_exist_ok=True)
shutil.copytree("tb", submission_dir.joinpath("tb"), dirs_exist_ok=True)
shutil.copy(png_dir, submission_dir.joinpath(png_name))

py_files = [
    "config.py",
    "display.py",
    "game_controller.py",
    "verilog_interface.py",
]

for f in py_files:
    shutil.copy(f, submission_dir.joinpath(f))

shutil.make_archive(bits_id + "_Lab9", 'zip', submission_dir)
shutil.rmtree(submission_dir, ignore_errors=True)

print(f"You are: {name.title() if name != bits_id else name}. Your submission zip file has been created.")
print(f"Upload BOTH of these files to QuantaAWS:")
print(f"- {png_name}")
print(f"- {zip_name}")
