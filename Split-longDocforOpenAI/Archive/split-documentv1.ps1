# Set the desired word count per document
$WordsPerDocument = 2048

# Load the Word application and open the selected document
$Word = New-Object -ComObject Word.Application
$Document = $Word.Documents.Open("C:\Users\Abdullah.Ollivierre\OneDrive - Canada Computing Inc\Desktop\MS Intune Suite Video Transcript.docx")

# Split the document into multiple files
$Paragraphs = $Document.Content.Paragraphs
$ParaCount = $Paragraphs.Count
$DocCount = [Math]::Ceiling($ParaCount / $WordsPerDocument)
for ($i = 0; $i -lt $DocCount; $i++) {
    $StartPara = $i * $WordsPerDocument
    $EndPara = [Math]::Min(($i + 1) * $WordsPerDocument, $ParaCount)
    $FileName = "SplitDocument_" + ($i + 1) + ".docx"
    $NewDoc = $Word.Documents.Add()
    for ($j = $StartPara; $j -lt $EndPara; $j++) {
        $NewDoc.Content.InsertAfter($Paragraphs.Item($j).Range.Text)
    }
    $NewDoc.SaveAs("C:\Users\Abdullah.Ollivierre\OneDrive - Canada Computing Inc\Desktop\$FileName")
    $NewDoc.Close()
}

# Close the selected document and the Word application
$Document.Close()
$Word.Quit()

