#!/bin/bash

mkgif() {
	palette="/tmp/palette.png"    
	filters="fps=15,scale=320:-1:flags=lanczos"
	
	inputFileName=$1
	outputFileName="$(basename "$fileName" .mov).gif"
	echo "Saving $outputFileName"

    echo Converting the video to gif
	ffmpeg -v warning -i $inputFileName -vf "$filters,palettegen" -y $palette
	ffmpeg -v warning -i $inputFileName -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $outputFileName
}

for fileName in "$@"
do
	mkgif $fileName
done