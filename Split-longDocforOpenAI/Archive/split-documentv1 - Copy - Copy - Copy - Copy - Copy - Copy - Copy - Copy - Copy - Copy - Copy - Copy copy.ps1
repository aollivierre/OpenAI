# Set the desired word count per document
$WordsPerDocument = 2500

# Read the text from the input file
$InputText = Get-Content "C:\Code\Split-longDocforOpenAI\Input\input.txt"

# Split the text into multiple files
$WordCount = ($InputText -split '\s+').Count
$DocCount = [Math]::Ceiling($WordCount / $WordsPerDocument)
$UpperBound = 50MB

$FromStream = [System.IO.StreamReader]::new("C:\Code\Split-longDocforOpenAI\Input\input.txt")
$Count = $Idx = 0

try {
    do {
        "Reading $UpperBound"
        $Buffer = [char[]]::new($UpperBound)
        $Count = $FromStream.ReadBlock($Buffer, 0, $Buffer.Length)
        if ($Count -gt 0) {
            $InputTextBlock = [string]::new($Buffer[0..($Count-1)])
            $WordCountBlock = ($InputTextBlock -split '\s+').Count
            $FileName = "SplitDocument_$($Idx+1).txt"
            Set-Content -Path "C:\Code\Split-longDocforOpenAI\Output\$FileName" -Value $InputTextBlock
            Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Created $($FileName) with $($WordCountBlock) words." -ForegroundColor Green
        }
        $Idx ++
    } while ($Count -gt 0 -and $Idx -lt $DocCount)
} finally {
    $FromStream.Close()
}

# Notify the user that the splitting process is complete
Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The input text has been split into $($Idx) files." -ForegroundColor Yellow
