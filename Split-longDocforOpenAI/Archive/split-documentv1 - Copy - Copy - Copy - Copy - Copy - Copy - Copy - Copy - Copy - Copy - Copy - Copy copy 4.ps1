# Read the text from the input file
$InputText = Get-Content "C:\Code\Split-longDocforOpenAI\Input\input.txt"

# Set output directory
$OutputDir = "C:\Code\Split-longDocforOpenAI\Output"

# Define maximum number of words per file
$maxWordsPerFile = 2500

# Initialize output file index and current number of words
$outputFileIndex = 1
$currentWords = 0

# Get the start time
$startTime = Get-Date

# Iterate through each line of the input file
foreach ($line in $InputText) {
    # Count the number of words in the current line
    $wordsInLine = ($line -split '\s+').Count

    # If adding this line to the current file would exceed the maximum number of words, start a new output file
    if (($currentWords + $wordsInLine) -gt $maxWordsPerFile) {
        # Increment output file index and reset current number of words
        $outputFileIndex++
        $currentWords = 0
    }

    # Append the current line to the current output file
    $outputFilePath = Join-Path $OutputDir "output-$outputFileIndex.txt"
    Add-Content $outputFilePath $line

    # Update the current number of words
    $currentWords += $wordsInLine

    # Output progress to the console
    $elapsedTime = (Get-Date) - $startTime
    $fileName = "output-$outputFileIndex.txt"
    $wordCount = (Get-Content $outputFilePath | Measure-Object -Word).Words
    Write-Host "$elapsedTime - $fileName ($wordCount words)" -ForegroundColor Green
}

# Output summary to the console
$totalElapsed = (Get-Date) - $startTime
$totalFiles = (Get-ChildItem $OutputDir | Measure-Object).Count
$totalWords = (Get-Content "$OutputDir\*.txt" | Measure-Object -Word).Words
Write-Host "Finished splitting file into $totalFiles files with a total of $totalWords words in $totalElapsed" -ForegroundColor Cyan
