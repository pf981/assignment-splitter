#!/bin/bash

printUsage() {
  echo "Usage: $0 [output1.txt] [output2.txt] ..."
}

EXTENSION='.c'
SPLIT_REGEX='/final/main.c Page 1$/'

# Removes the path and extension of the parameter
stripPath() {
  # Remove path
  noExt=${1##*/}

  # Remove the extension
  echo ${noExt%.*}
}

# Uses the file $1 to creat folder, splits$1, which contains the split files
splitSingleFile() {
  outputFile=$1
  splitFolder=`stripPath $1` # If the file is "a/b/output.txt" the folder will be "output"

  # Ensure the file exists
  if [[ ! -f $outputFile ]]; then
    echo "\"$outputFile\" not found." >&2
    exit 1
  fi

  # Make directory and move output file
  if ! (mkdir $splitFolder && cp $outputFile $splitFolder/$outputFile); then
    echo "Problem making directory or moving file." >&2
    exit 1
  fi

  cd $splitFolder/
#  split -p "final/main.c Page 1$" $outputFile # FIXME: Use csplit as split -p is Mac specific
  csplit -k $outputFile "$SPLIT_REGEX" {99} > /dev/null 2>&1

  i=1
  for f in x*; do
    studUsername=`head -n 1 $f | sed 's|.*/\(.*\)/final/main.c Page 1$|\1|'`
    mv $f "`printf '%02d' $i` ${studUsername}${EXTENSION}"
    let "i += 1"
  done

  cd ..
}

main() {
  # Ensure at least one argument is given
  [[ $# -gt 0 ]] || { printUsage; exit 1; }

  # For each paramater
  while [[ $# -gt 0 ]]; do
    # Split the file
    splitSingleFile "$1"
    shift
  done
}

main "$@"
