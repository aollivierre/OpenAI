# Set the desired word count per document
$WordsPerDocument = 2500

# Read the text from the input file
$InputText = Get-Content "C:\Code\Split-longDocforOpenAI\Input\input.txt"

# Set output directory
$OutputDir = "C:\Code\Split-longDocforOpenAI\Output"

# Create output directory if it does not exist
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Split the text into multiple files
$WordCount = ($InputText -split '\s+').Count
$DocCount = [Math]::Ceiling($WordCount / $WordsPerDocument)
$InputTextIndex = 0
for ($i = 0; $i -lt $DocCount; $i++) {
    $FileName = "SplitDocument_" + ($i + 1) + ".txt"
    $OutputFilePath = Join-Path $OutputDir $FileName
    $WordCountBlock = 0
    $StreamWriter = New-Object System.IO.StreamWriter($OutputFilePath)
    try {
        while ($WordCountBlock -lt $WordsPerDocument -and $InputTextIndex -lt $WordCount) {
            $StreamWriter.Write($InputText[$InputTextIndex] + " ")
            $InputTextIndex++
            $WordCountBlock++
        }
    } finally {
        $StreamWriter.Close()
    }
    Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Created $($FileName) with $($WordCountBlock) words." -ForegroundColor Green
}

# Notify the user that the splitting process is complete
Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The input text has been split into $DocCount files." -ForegroundColor Yellow
