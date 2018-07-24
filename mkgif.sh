#!/bin/bash

mkgif() {
	palette="/tmp/palette.png"    
	filters="fps=15,scale=320:-1:flags=lanczos"
	
	inputFileName=$1
	outputFileName="$(basename "$fileName" .mov).gif"
	echo "Saving $outputFileName"

	echo Creating a video from the current simulator
    xcrun simctl io booted recordVideo --type=mp4 $inputFileName
    wait

    echo Converting the video to gif
	ffmpeg -v warning -i $inputFileName -vf "$filters,palettegen" -y $palette
	ffmpeg -v warning -i $inputFileName -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $outputFileName
	
	echo Removing the temporary file
	rm -f $inputFileName
}

for fileName in "$@"
do
	mkgif $fileName
done