# Get all MSE files matching the pattern
$files = Get-ChildItem -Filter "MSEvsSNR_*sps.txt"

# Define the exact roll-off array matching your data layout (a = 0.00:0.05:1.00)
$rolloffs = @("0.0", "0.05", "0.1", "0.15", "0.2", "0.25", "0.3", "0.35", "0.4", "0.45", "0.5", "0.55", "0.6", "0.65", "0.7", "0.75", "0.8", "0.85", "0.9", "0.95", "1.0")

foreach ($file in $files) {
    $outputPath = Join-Path $file.DirectoryName ($file.BaseName + "_flattened.txt")
    Write-Host "Processing $($file.Name) -> $($file.BaseName)_flattened.txt..."

    # Read all lines from the file
    $lines = Get-Content $file.FullName
    
    # Open a clean stream writer for performance
    $stream = [System.IO.StreamWriter]::$outputPath
    
    # Write the new header
    $stream.WriteLine("SNR_dB`tRollOff`tMSE")

    # Skip the original header line (index 0) and iterate through rows
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ([string]::IsNullOrWhiteSpace($lines[$i])) { continue }
        
        # Split row by tabs
        $columns = $lines[$i].Split("`t")
        $snr = $columns[0] # First column is SNR_dB

        # Map each MSE column to its corresponding roll-off factor
        for ($j = 1; $j -lt $columns.Count; $j++) {
            $mse = $columns[$j]
            $alpha = $rolloffs[$j-1]
            
            # Write row in long format
            $stream.WriteLine("$snr`t$alpha`t$mse")
        }
        
        # CRITICAL FOR PGFPLOTS: Add an empty line after completing a full X-scan line (SNR step)
        $stream.WriteLine("")
    }

    $stream.Close()
}
Write-Host "Preprocessing complete!" -ForegroundColor Green