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
$InputText = Get-Content "C:\Code\OpenAI\Split-longDocforOpenAI\Input\Input.txt" -Raw

# Define maximum number of words per file
$maxWordsPerFile = 10000

# Initialize output file index and current number of words
$outputFileIndex = 1
$currentWords = 0

# Split the text into an array of words
$wordsArray = $InputText -split '\s+'

# Start the first output file
$outputFilePath = Join-Path $OutputDir "output-$outputFileIndex.txt"
$outputFileContent = "This is part number $outputFileIndex`n"

# Iterate through each word in the array
foreach ($word in $wordsArray) {
    # If adding this word to the current file would exceed the maximum number of words, start a new output file
    if ($currentWords -ge $maxWordsPerFile) {
        # Write the content to the current output file
        Add-Content $outputFilePath $outputFileContent

        # Increment output file index and reset current number of words
        $outputFileIndex++
        $currentWords = 0

        # Start a new output file
        $outputFilePath = Join-Path $OutputDir "output-$outputFileIndex.txt"
        $outputFileContent = "This is part number $outputFileIndex`n"
    }

    # Append the current word to the current output file content
    $outputFileContent += "$word "

    # Update the current number of words
    $currentWords++
}

# Write the content to the last output file
Add-Content $outputFilePath $outputFileContent

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