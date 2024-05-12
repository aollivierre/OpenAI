# Set output directory
$OutputDir = "C:\Code\OpenAI\Split-longDocforOpenAI\Output"

# Remove any existing files in the output directory
$existingFiles = Get-ChildItem $OutputDir -Filter "output-*.txt"
if ($existingFiles.Count -gt 0) {
    Write-Host "$(Get-Date) - Removing existing output files..." -ForegroundColor Yellow
    $existingFiles | ForEach-Object {
        Write-Host "$(Get-Date) Removing file $($_.FullName)..." -ForegroundColor Yellow
    }
    $existingFiles | Remove-Item -Force
    Write-Host "$(Get-Date) - Removed $($existingFiles.Count) existing output files." -ForegroundColor Yellow
}

# Read the text from the input file
$InputText = Get-Content "C:\Code\OpenAI\Split-longDocforOpenAI\Input\Input.txt"

# Define maximum number of words per file
$maxWordsPerFile = 1500

# Initialize output file index and current number of words
$outputFileIndex = 1
$currentWords = 0

# Iterate through each line of the input file
foreach ($line in $InputText) {
    # Count the number of words in the current line
    $wordsInLine = ($line -split '\s+').Count

    # If adding this line to the current file would exceed the maximum number of words, start a new output file
    if (($currentWords + $wordsInLine) -gt $maxWordsPerFile) {
        # Increment output file index and reset current number of words
        $outputFileIndex++
        $currentWords = 0

        # Output summary for the previous file
        $prevOutputFilePath = Join-Path $OutputDir "output-$($outputFileIndex-1).txt"
        $wordCount = (Get-Content $prevOutputFilePath | Measure-Object -Word).Words
        Write-Host "$(Get-Date) - Finished writing $prevOutputFilePath ($wordCount words)" -ForegroundColor Cyan
    }

    # Append the current line to the current output file
    $outputFilePath = Join-Path $OutputDir "output-$outputFileIndex.txt"
    if (!(Test-Path $outputFilePath)) {
        Add-Content $outputFilePath "This is part number $outputFileIndex`n"
    }
    Add-Content $outputFilePath $line

    # Update the current number of words
    $currentWords += $wordsInLine
}

# Output summary for the last file
$lastOutputFilePath = Join-Path $OutputDir "output-$outputFileIndex.txt"
$wordCount = (Get-Content $lastOutputFilePath | Measure-Object -Word).Words
Write-Host "$(Get-Date) - Finished writing $lastOutputFilePath ($wordCount words)" -ForegroundColor Cyan

# Output summary of total word count
$totalWordCount = 0
Get-ChildItem $OutputDir -Filter "output-*.txt" | ForEach-Object {
    $wordCount = (Get-Content $_.FullName | Measure-Object -Word).Words
    Write-Host "File $_ contains $wordCount words" -ForegroundColor Green
    $totalWordCount += $wordCount
}
Write-Host "Total word count: $totalWordCount" -ForegroundColor Cyan
