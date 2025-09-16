#!/bin/bash
# usage: ./run.sh file.v

if [ -z "$1" ]; then
    echo "usage: $0 <verilog_file>"
    exit 1
fi

filename=$(basename -- "$1")
basename="${filename%.*}"

iverilog -o "$basename" "$1"
vvp "$basename"
