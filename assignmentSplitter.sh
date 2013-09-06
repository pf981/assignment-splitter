#!/bin/bash

outputFile='output.txt'
splitFolder='splits'

# Ensure the file exists
if [[ ! -f $outputFile ]]; then
  echo "$outputFile not found." >&2
  exit 1
fi

# Make directory and move output file
if ! (mkdir $splitFolder && cp $outputFile $splitFolder/$outputFile); then
  echo "Problem making directory or moving file." >&2
  exit 1
fi

cd $splitFolder/
split -p "final/main.cPage 1$" $outputFile

i=1
for f in x*; do
  studUsername=`head -n 1 $f | sed 's|.*/\(.*\)/final/main.cPage 1$|\1|'`
  mv $f "`printf '%02d' $i` $studUsername"
  let "i += 1"
done
