#!/bin/bash

LINES=20 top -b -o %CPU -n1 -w > top_20_cpu.txt

top_20=$(awk 'FNR>=7 {print $2,$9}' top_20_cpu.txt)

echo $top_20

overages=0

# Loop through each line of the extracted data using a for loop
for line in $top_20; do
    # Split the line into user and cpu using awk or shell parameter expansion
    user=$(echo $line | awk '{print $1}')
    cpu=$(echo $line | awk '{print $2}')

    # Check if the CPU usage exceeds the threshold
    if [[ $(echo "$cpu" | awk '{print int($1)}') -ge 55 ]]; then
        overages=$((overages + 1))
    fi
done

# Check if there were any overages
if [[ $overages -eq 0 ]]; then
    echo "Your programs are not experiencing high CPU."
else
    echo "You have $overages programs experiencing high CPU!"
fi
