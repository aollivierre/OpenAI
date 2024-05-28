#!/bin/bash

# Set output directory
OutputDir="/Users/abdullah/code/OpenAI/Split-longDocforOpenAI/Output"

# Remove any existing files in the output directory
echo "$(date) - Removing existing output files..."
rm -f $OutputDir/output-*.txt

# Read the text from the input file
InputText=$(cat "/Users/abdullah/code/OpenAI/Split-longDocforOpenAI/Input/Input.txt")

# Define maximum number of words per file
maxWordsPerFile=4500

# Initialize output file index and current number of words
outputFileIndex=1
currentWords=0

# Start the first output file
outputFilePath="$OutputDir/output-$outputFileIndex.txt"
outputFileContent="This is part number $outputFileIndex\n"

# Split the text into an array of words
read -a wordsArray <<< $InputText

# Iterate through each word in the array
for word in "${wordsArray[@]}"; do
    # If adding this word to the current file would exceed the maximum number of words, start a new output file
    if [[ $currentWords -ge $maxWordsPerFile ]]; then
        # Write the content to the current output file
        echo -e $outputFileContent > $outputFilePath

        # Increment output file index and reset current number of words
        outputFileIndex=$((outputFileIndex + 1))
        currentWords=0

        # Start a new output file
        outputFilePath="$OutputDir/output-$outputFileIndex.txt"
        outputFileContent="This is part number $outputFileIndex\n"
    fi

    # Append the current word to the current output file content
    outputFileContent+="$word "

    # Update the current number of words
    currentWords=$((currentWords + 1))
done

# Write the content to the last output file
echo -e $outputFileContent > $outputFilePath

# Output summary for the last file
lastOutputFilePath="$OutputDir/output-$outputFileIndex.txt"
wordCount=$(wc -w < $lastOutputFilePath)
echo "$(date) - Finished writing $lastOutputFilePath ($wordCount words)"

# Output summary of total word count
totalWordCount=0
for file in $OutputDir/output-*.txt; do
    wordCount=$(wc -w < $file)
    echo "File $file contains $wordCount words"
    totalWordCount=$((totalWordCount + wordCount))
done
echo "Total word count: $totalWordCount"