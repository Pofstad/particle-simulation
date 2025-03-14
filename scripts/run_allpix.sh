#!/bin/bash

# Get the absolute path to the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Define files to track run numbers and dates
RUN_FILE="$PROJECT_ROOT/last_run.txt"
DATE_FILE="$PROJECT_ROOT/last_date.txt"

# Get today's date in YYMMDD format
TODAYS_DATE=$(date +%y%m%d)

# Check if the date has changed; reset run number if it's a new day
if [ -f "$DATE_FILE" ] && [ "$(cat "$DATE_FILE")" == "$TODAYS_DATE" ]; then
    # Continue incrementing run number
    RUN_NUMBER=$(cat "$RUN_FILE")
    RUN_NUMBER=$((RUN_NUMBER + 1))
else
    # Reset run number for a new day
    RUN_NUMBER=1
    echo "$TODAYS_DATE" > "$DATE_FILE"  # Store today's date
fi

# Save the updated run number
echo "$RUN_NUMBER" > "$RUN_FILE"

# Define Corryvreckan output filename (Allpix handles directories)
CORRY_FILE="${TODAYS_DATE}_run${RUN_NUMBER}.root"

# Display run info
echo "--------------------------------------"
echo "Starting Allpix Squared Simulation"
echo "Run Number: $RUN_NUMBER"
echo "Date: $TODAYS_DATE"
echo "Corryvreckan Output File: $CORRY_FILE"
echo "--------------------------------------"

# Run Allpix Squared simulation with correct absolute paths
allpix -c "$PROJECT_ROOT/configs/allpix/allpixsim.conf" -o CorryvreckanWriter.file_name="$CORRY_FILE"

echo "Simulation completed for Run $RUN_NUMBER. Output saved as $CORRY_FILE."
