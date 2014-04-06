#!/bin/bash
# FIXME: TODO: Make it run with $ assignmentSplitter CL01.txt CL02.txt CL04.txt    and it gives folders splitCL01 splitCL02 splitCL03

printUsage() {
  echo "Usage: $0 [output1.txt] [output2.txt] ..."
}

stripPath() { # FIXME: Doesn't Work
  noExt=${1%.*}
  noPath=${noExt##*/}
  return $noPath
}

# Uses the file $1 to creat folder, splits$1, which contains the split files
splitSingleFile() {
  outputFile=$1
  splitFolder="splits$1"
#  splitFolder=`stripPath $1` # fixme: should be split+pathlessnamewithnoextension

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
  split -p "final/main.c Page 1$" $outputFile

  i=1
  for f in x*; do
    studUsername=`head -n 1 $f | sed 's|.*/\(.*\)/final/main.c Page 1$|\1|'`
    mv $f "`printf '%02d' $i` $studUsername"
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
    splitSingleFile $1
    shift
  done
}

main "$@"
