# Set the desired word count per document
$WordsPerDocument = 2500

# Read the text from the input file
$InputText = Get-Content "C:\Code\Split-longDocforOpenAI\Input\input.txt" -Raw

# Split the text into multiple files
$WordCount = ($InputText -split '\s+').Count
$DocCount = [Math]::Ceiling($WordCount / $WordsPerDocument)
$Buffer = new-object byte[] 1MB
$FileIndex = 0
$WordIndex = 0
$BytesWritten = 0
$OutputFile = $null
$StreamWriter = $null

for ($i = 0; $i -lt $DocCount; $i++) {
    $FileName = "SplitDocument_" + ($i + 1) + ".txt"
    $OutputFile = "C:\Code\Split-longDocforOpenAI\Output\$FileName"
    $StreamWriter = [System.IO.StreamWriter]::new($OutputFile)

    do {
        $WordsRemaining = $WordsPerDocument - $WordIndex
        $BytesToRead = [Math]::Min($WordsRemaining * 2, $Buffer.Length)
        $InputBuffer = $InputText.Substring($BytesWritten, $BytesToRead)
        $WordIndex += ($InputBuffer -split '\s+').Count

        $StreamWriter.Write($InputBuffer)
        $StreamWriter.Flush()

        $BytesWritten += $BytesToRead
    } while ($BytesWritten -lt $InputText.Length - 1 - $Buffer.Length - $BytesToRead)

    $StreamWriter.Dispose()

    $WordCountBlock = $WordIndex
    Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Created $($FileName) with $($WordCountBlock) words." -ForegroundColor Green
}

# Notify the user that the splitting process is complete
Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The input text has been split into $DocCount files." -ForegroundColor Yellow
