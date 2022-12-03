$FileContent = Get-Content .\input.txt -Raw 
$Lines = $FileContent -split "`n"
$TotalValue = 0
$Line1 = ""
$Line2 = ""
$Line3 = ""
ForEach($line in $lines)
{
    $line = $line.Trim()
    If($Line1.Length -eq 0)
    {
        $Line1 = $line
    }
    ElseIf($Line2.Length -eq 0)
    {
        $Line2 = $line
    }
    ElseIf($Line3.Length -eq 0)
    {
        $Line3 = $line
        Write-Host($Line1)
        Write-Host($Line2)
        Write-Host($Line3)

        $value = 0
        ForEach($letter1 in [char[]]$line1)
        {
            If($value -gt 0)
            {
                continue;
            }
            Write-Host("Checking $letter1")
            ForEach($letter2 in [char[]]$line2)
            {
                If($value -gt 0)
                {
                    continue;
                }
                If([byte]$letter1 -eq [byte]$letter2)
                {
                    ForEach($letter3 in [char[]]$line3)
                    {
                        If($value -gt 0)
                        {
                            continue;
                        }
                        If([byte]$letter1 -eq [byte]$letter3)
                        {
                            $value = [byte]$letter1
                            If($value -gt 91)
                            {
                                $value = $value - 96 #Drops lower case letters to starting at 1
                            }
                            Else
                            {
                                $value = $value - 38 #Drops upper case letters to starting at 27
                            }
                            Write-Host("$letter1 " + $value)
                            $TotalValue = $TotalValue + $value

                            continue;
                        }
                    }
                }
            }
        }

        $Line1 = ""
        $Line2 = ""
        $Line3 = ""
    }
}
Write-Host("Total Value: $TotalValue")