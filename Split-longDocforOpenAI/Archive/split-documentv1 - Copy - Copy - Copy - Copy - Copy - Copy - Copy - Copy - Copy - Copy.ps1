$InputFile = "C:\Code\Split-longDocforOpenAI\Input\input.txt"
$OutputFolder = "C:\Code\Split-longDocforOpenAI\Output"
$ChunkSize = 2048

$InputText = Get-Content $InputFile -Raw
$WordCount = ($InputText -split '\s+').Count
$ChunkCount = [Math]::Ceiling($WordCount / $ChunkSize)

for ($i = 0; $i -lt $ChunkCount; $i++) {
    $StartIndex = $i * $ChunkSize
    $EndIndex = [Math]::Min(($i + 1) * $ChunkSize - 1, $WordCount - 1)
    $ChunkText = $InputText.Split()[($StartIndex)..($EndIndex)] -join ' '
    $ChunkFileName = "SplitDocument_" + ($i + 1) + ".txt"
    $ChunkFilePath = Join-Path $OutputFolder $ChunkFileName
    Set-Content -Path $ChunkFilePath -Value $ChunkText
    $ChunkWordCount = ($ChunkText -split '\s+').Count
    Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Created $($ChunkFileName) with $($ChunkWordCount) words." -ForegroundColor Green
}

Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - The input text has been split into $($ChunkCount) files." -ForegroundColor Yellow
