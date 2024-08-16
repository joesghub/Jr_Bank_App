#!/bin/bash

#The purpose of this script is to check for system resources and to have conditional statements for IF a certain resource exceeds a certain set threshold.  
#IF it does.. THEN it should EXIT the script with an error.  ELSE the script completes.
#Keep in mind: Who is running this script? When does the script run? Why is it important to have this conditional, especially for a CICD pipeline stage?
#There are many commands in BASH that can be used to observe system resources

#Shows system resources sorted by CPU (-o %CPU) in batches (-b) refreshing every 10 seconds (-d10) for 3 intervals (-n3) for the 20 processes (LINES=20 ... -w)
#https://www.linode.com/docs/guides/top-htop-iotop/
#https://stackoverflow.com/questions/38654087/how-to-limit-the-number-of-rows-in-top-command-output-on-non-interactive-mode-fo
#(V1)LINES=20 top -b -o %CPU -d10 -n3 -w 
LINES=20 top -b -o %CPU -n1 -w > top_20_cpu.txt


#Checking the CPU after the first 6 lines ('FNR>-7 ') then isolating the user and %cpu column values ({print $2,$9})
#https://www.unix.com/unix-for-dummies-questions-and-answers/259716-how-print-specific-range-using-awk.html
top_20=$(awk 'FNR>=7 {print $2,$9}' top_20_cpu.txt)

#prints the contents of the text file stored in a variable
echo $top_20

#Starts a counter that gets increased by 1 for each overage found later
overages=0

#This sets the Internal Field Separator (IFS) to a newline character, so the for loop treats each line of top_20 as a separate item. 
#This is important because otherwise, the loop would split on spaces, which would cause issues with the data.
IFS=$'\n'

# Loop through each line of the extracted data using a for loop
for line in $top_20; do
    # Split the line into user and cpu using awk or shell parameter expansion
    user=$(echo $line | awk '{print $1}')
    cpu=$(echo $line | awk '{print $2}')

    # Check if the CPU ([[ $(echo "$cpu"...) ]]) usage converted to an integer (awk '{print int($1)}') exceeds (-ge) the threshold (55)
    if [[ $(echo "$cpu" | awk '{print int($1)}') -ge 55 ]]; then
        overages=$((overages + 1))
    fi
done

#Check if there were any overages. If there are it will state how many. 
#https://www.geeksforgeeks.org/how-to-use-exit-code-to-read-from-terminal-from-script-and-with-logical-operators/
if [[ $overages -eq 0 ]]; then
    echo "Your programs are not experiencing high CPU."
else
    echo "You have $overages programs experiencing high CPU!"
fi


