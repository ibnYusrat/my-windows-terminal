Write-Host "Installing oh-my-posh from Microsoft Store"
winget install oh-my-posh -s msstore --accept-package-agreements --accept-source-agreements
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements

oh-my-posh init pwsh | Invoke-Expression

Get-PoshThemes

if (!(Test-Path $PROFILE))
{
   New-Item -Path $PROFILE -Type File -Force
   Write-Host "Created empty file for Powershell Profile"
}
Add-Content -Path $PROFILE "oh-my-posh init pwsh | Invoke-Expression"
Add-Content -Path $PROFILE -value "Add-Alias open explorer.exe"
#Font-Installation Script credit: https://gist.github.com/anthonyeden/0088b07de8951403a643a8485af2709b

$SourceDir   = ".\fonts\"
$Source      = ".\fonts\*"
$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
$TempFolder  = "C:\Windows\Temp\Fonts"

New-Item $TempFolder -Type Directory -Force | Out-Null

Get-ChildItem -Path $Source -Include '*.ttf','*.ttc','*.otf' -Recurse | ForEach {
    If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {

        $Font = "$TempFolder\$($_.Name)"
        
        # Copy font to local temporary folder
        Copy-Item $($_.FullName) -Destination $TempFolder
        
        # Install font
        $Destination.CopyHere($Font,0x10)

        # Delete temporary copy of font
        Remove-Item $Font -Force
    }
}

