#!/usr/bin/env python

import csv
import sys

if len(sys.argv) != 3:
    print("Usage: python script.py input_file output_file")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]

with open(input_file, "r") as infile, open(output_file, "w", newline="") as outfile:
    
    reader = csv.reader(infile)
    next(reader)
    writer = csv.writer(outfile, delimiter="\t")
    
    for row in reader:
        writer.writerow([row[1], row[0]])
