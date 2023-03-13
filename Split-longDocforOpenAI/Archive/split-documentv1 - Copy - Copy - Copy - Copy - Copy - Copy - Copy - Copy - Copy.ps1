$InputPath = "C:\Code\Split-longDocforOpenAI\Input\"
$OutputPath = "C:\Code\Split-longDocforOpenAI\Output\"
$FileExtension = "txt"
$FileSize = 50MB

# Get the files in the input directory with the specified extension
$Files = Get-ChildItem -Path $InputPath -Filter "*.$FileExtension" -File

# Loop through each file and split it into smaller files
foreach ($File in $Files) {
    # Open the input file for reading
    $FromFile = [System.IO.File]::OpenRead($File.FullName)

    try {
        # Initialize variables for the output file
        $ToFile = $null
        $FileIndex = 0
        $BytesWritten = 0

        while ($BytesWritten -lt $FromFile.Length) {
            # Create a new output file if needed
            if (!$ToFile) {
                $FileName = "{0}{1}_{2}.{3}" -f $OutputPath, $File.BaseName, $FileIndex, $FileExtension
                $ToFile = [System.IO.File]::OpenWrite($FileName)
            }

            # Read a chunk of data from the input file
            $Buffer = New-Object byte[] $FileSize
            $BytesRead = $FromFile.Read($Buffer, 0, $FileSize)

            # Write the chunk of data to the output file
            $ToFile.Write($Buffer, 0, $BytesRead)
            $BytesWritten += $BytesRead

            # Close the output file and reset variables if it reaches the size limit
            if ($BytesWritten -ge $FileSize) {
                $ToFile.Close()
                $ToFile = $null
                $FileIndex++
                $BytesWritten = 0
            }
        }
    }
    finally {
        # Close the input and output files
        $FromFile.Close()
        if ($ToFile) {
            $ToFile.Close()
        }
    }
}
