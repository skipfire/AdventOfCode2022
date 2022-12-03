$FileContent = Get-Content .\input.txt -Raw 
$Lines = $FileContent -split "`n"
$TotalValue = 0
ForEach($line in $lines)
{
    $value = 0
    $line = $line.Trim()
    $Left = $line.Substring(0, $line.Length/2)
    $Right = $line.Substring($line.Length/2)
    Write-Host($line);
    ForEach($letter in [char[]]$left)
    {
        If($value -gt 0)
        {
            continue;
        }
        ForEach($check in [char[]]$right)
        {
            If($value -gt 0)
            {
                continue;
            }
            If([byte]$letter -eq [byte]$check)
            {
                $value = [byte]$letter
                If($value -gt 91)
                {
                    $value = $value - 96 #Drops lower case letters to starting at 1
                }
                Else
                {
                    $value = $value - 38 #Drops upper case letters to starting at 27
                }
                Write-Host("$letter " + $value)
                $TotalValue = $TotalValue + $value

                continue;
            }
        }
    }
}
Write-Host("Total Value: $TotalValue")