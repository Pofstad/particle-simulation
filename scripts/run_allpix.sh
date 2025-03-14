#!/bin/bash

# Define the run number file
RUN_FILE="last_run.txt"
if [ ! -f "$RUN_FILE" ]; then
    echo 0 > "$RUN_FILE"
fi

# Increment the run number
RUN_NUMBER=$(cat "$RUN_FILE")
RUN_NUMBER=$((RUN_NUMBER + 1))
echo "$RUN_NUMBER" > "$RUN_FILE"

# Define date format (YYMMDD)
TODAYS_DATE=$(date +%y%m%d)

# Define output directories
OUTPUT_DIR="output"
CORRY_DIR="${OUTPUT_DIR}/CorryvreckanWriter"
mkdir -p "$CORRY_DIR"

# Define Corryvreckan output filename
CORRY_FILE="${CORRY_DIR}/${TODAYS_DATE}_run${RUN_NUMBER}.root"

# Display current run info
echo "--------------------------------------"
echo "Starting Allpix Squared Simulation"
echo "Run Number: $RUN_NUMBER"
echo "Date: $TODAYS_DATE"
echo "Output Directory: $OUTPUT_DIR"
echo "Corryvreckan Output File: $CORRY_FILE"
echo "--------------------------------------"

# Run Allpix Squared simulation with the updated Corryvreckan output file name
allpix -c configs/allpix/allpixsim.conf -o CorryvreckanWriter.file_name="$CORRY_FILE"

# Log changes to a log file
LOG_FILE="logs/run_log.txt"
mkdir -p logs
echo "Run: $RUN_NUMBER | Date: $(date)" >> "$LOG_FILE"
echo "Changes in configs/allpix/allpixsim.conf:" >> "$LOG_FILE"
git diff -- configs/allpix/allpixsim.conf >> "$LOG_FILE"
echo "----------------------------------" >> "$LOG_FILE"

# Commit logs to GitHub (only if in a Git repo)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git add "$LOG_FILE"
    git commit -m "Run $RUN_NUMBER log update"
    git push origin main
else
    echo "⚠ Not in a Git repository - Skipping Git logging..."
fi

echo "Simulation completed for Run $RUN_NUMBER. Output saved to $CORRY_FILE."
