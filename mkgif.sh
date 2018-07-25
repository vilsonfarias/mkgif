#!/bin/bash

verbose=false

process() {
  for fileName in "$@"
  do
  	convert "$fileName"
  done
}

capture() {
	inputFileName=$1
	
	if "$verbose" = true; then
		echo Creating the video $1 from the current simulator
	fi

    xcrun simctl io booted recordVideo --type=mp4 $inputFileName
    wait
    convert $inputFileName

    if "$verbose" = true; then
    	echo Removing the temporary file
    fi
    # rm -f $inputFileName
}

convert() {
	palette="/tmp/palette.png"    
	filters="fps=15,scale=320:-1:flags=lanczos"
	inputFileName="$1" 
	outputFileName="${inputFileName%.*}".gif
	echo $outputFileName

    if "$verbose" = true; then
    	echo Converting $inputFileName to gif file
	fi

	ffmpeg -v error -i $inputFileName -vf "$filters,palettegen" -y $palette
	ffmpeg -v error -i $inputFileName -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $outputFileName

	echo $outputFileName has been created
}

manual() {
	echo "Usage: "
	echo "   Convert multiple files to gif: "
	echo
	echo "     mkgif [-v] -f fileNames "
	echo 
	echo "     Parameters: "
	echo "     -v | --verbose: verbose commands "
	echo "     -f | --files: convert multiple files to gif "
	echo "     fileNames: list of filenames to be converted "
	echo    
	echo 
	echo "   Capture a video from iOS Simulator and convert it to gif: "
	echo
	echo "     mkgif [-v] fileName "
	echo
	echo "     Parameters: "
	echo "     -v | --verbose: verbose commands "
	echo "     file: destination gif file "
}

for arg in "$@"
do
    case "$arg" in
    -h|--help)
		manual
		break
		;;
    -v|--verbose) 
        verbose=true
        shift
        ;;
    -f|--files) #convert a file list instead of capturing from simulator
        shift
        process "$@"
        break
        ;;
    *)  
		shift
        capture "$1"
		break
	    ;;
    esac
done