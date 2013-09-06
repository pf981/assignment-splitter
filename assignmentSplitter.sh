#!/bin/bash

outputFile='output.txt'
splitFolder='splits'

# Ensure the file exists
if [[ ! -f $outputFile ]]; then
  echo "$outputFile not found." >&2
  exit 1
fi

# Make/cd directory and move output file
if [[ ! (mkdir $splitFolder) && (cp $outputFile $splitFolder/) && (cd $splitFolder) ]]; then
  echo "Problem making directory or moving file." >&2
  exit 1
fi

# Split the file
split -p "final/main.cPage 1$" $outputFile
