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

# Define output directories (relative to scripts/)
OUTPUT_DIR="../output"
CORRY_DIR="${OUTPUT_DIR}/CorryvreckanWriter"
mkdir -p "$CORRY_DIR"

# Define correct Corryvreckan output filename
CORRY_FILE="${CORRY_DIR}/${TODAYS_DATE}_run${RUN_NUMBER}.root"

# Display run info
echo "--------------------------------------"
echo "Starting Allpix Squared Simulation"
echo "Run Number: $RUN_NUMBER"
echo "Date: $TODAYS_DATE"
echo "Output Directory: $OUTPUT_DIR"
echo "Corryvreckan Output File: $CORRY_FILE"
echo "--------------------------------------"

# Run Allpix Squared simulation with correct file path
allpix -c ../configs/allpixsim.conf -o CorryvreckanWriter.file_name="$CORRY_FILE"


echo "Simulation completed for Run $RUN_NUMBER. Output saved to $CORRY_FILE."
