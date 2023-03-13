# Set the desired word count per document
$WordsPerDocument = 2048

# Read the text from the input file
$InputText = Get-Content "C:\Code\Split-longDocforOpenAI\Input\input.txt"

# Split the text into multiple files
$WordCount = ($InputText -split '\s+').Count
$DocCount = [Math]::Ceiling($WordCount / $WordsPerDocument)
for ($i = 0; $i -lt $DocCount; $i++) {
    $StartWord = $i * $WordsPerDocument
    $EndWord = [Math]::Min(($i + 1) * $WordsPerDocument, $WordCount)
    $FileName = "SplitDocument_" + ($i + 1) + ".txt"
    $InputTextBlock = $InputText[($StartWord)..($EndWord - 1)] -join ' '
    Set-Content -Path "C:\Code\Split-longDocforOpenAI\Output\$FileName" -Value $InputTextBlock
    $WordCountBlock = ($InputTextBlock -split '\s+').Count
    Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Created $($FileName) with $($WordCountBlock) words." -ForegroundColor Green
}

# Notify the user that the splitting process is complete
Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The input text has been split into $DocCount files." -ForegroundColor Yellow
