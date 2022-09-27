Write-Host "Installing Windows Terminal.."
winget install 9N0DX20HK701 -s msstore --accept-package-agreements --accept-source-agreements

Write-Host "Installing PowerShell:"
winget install 9MZ1SNWT0N5D -s msstore --accept-package-agreements --accept-source-agreements

Write-Host "Installing oh-my-posh from Microsoft Store"
winget install oh-my-posh -s msstore --accept-package-agreements --accept-source-agreements
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements

Write-Host "Initialize oh-my-posh"
oh-my-posh init pwsh | Invoke-Expression

Write-Host "Fetch oh-my-posh themes:"
Get-PoshThemes

Write-Host "Installing fonts.."
$Source = ".\fonts\*"
$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
$TempFolder = "C:\Windows\Temp\Fonts"

New-Item $TempFolder -Type Directory -Force | Out-Null

# Install Fonts
Get-ChildItem -Path $Source -Include '*.ttf', '*.ttc', '*.otf' -Recurse | ForEach {
    If (-not(Test-Path "C:\Windows\Fonts\$( $_.Name )"))
    {
        $Font = "$TempFolder\$( $_.Name )"
        Copy-Item $( $_.FullName ) -Destination $TempFolder
        $Destination.CopyHere($Font, 0x10)
        Remove-Item $Font -Force
    }
}

Write-Host "Updating PowerShell Profile";

if (!(Test-Path $PROFILE))
{
    New-Item -Path $PROFILE -Type File -Force
    Write-Host "Created empty file for Powershell Profile (it didn't exist..)"
}

Add-Content -Path $PROFILE "oh-my-posh init pwsh --config '$env:POSH_THEMES_PATH\hunk.omp.json' | Invoke-Expression"
Add-Content -Path $PROFILE -value "Set-Alias open explorer.exe"

Write-Host "Update Windows Terminal Config..";

$PowerShellPathToJSON = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

$PowerShellSettings = Get-Content $PowerShellPathToJSON -raw | ConvertFrom-Json
$PowerShellProfileId = "";

$PowerShellSettings.profiles.list | % {
    if ($_.name -eq 'PowerShell')  {
        $_.font = {  face: "MesloLGS NF"  }
        $_.useAcrylic = $True
        $_.opacity = 60
        $PowerShellProfileId = $_.guid
    }
}

$PowerShellSettings.defaultProfile = $PowerShellProfileId;
$PowerShellSettings.useAcrylicInTabRow = $True;

$PowerShellSettings | ConvertTo-Json -depth 5 | set-content $PowerShellPathToJSON

Clear-Host;

Write-Host "If everything went well, you should be good to go. Just exist Windows PowerShell and launch Windows Terminal from the start menu.";
Write-Host "";

Write-Host -NoNewLine 'Press any key to exit Windows Powershell...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
exit