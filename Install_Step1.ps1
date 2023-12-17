Write-Host "Installing Windows Terminal.."
winget install 9N0DX20HK701 -s msstore --accept-package-agreements --accept-source-agreements

Write-Host "Installing PowerShell:"
winget install 9MZ1SNWT0N5D -s msstore --accept-package-agreements --accept-source-agreements

Write-Host "Installing oh-my-posh.."
winget install oh-my-posh -s msstore --accept-package-agreements --accept-source-agreements
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements

Write-Host "Installing jq"
winget install jqlang.jq --accept-source-agreements


Write-Host "Installing Lua"
winget install DEVCOM.Lua --accept-source-agreements


Write-Host "Please exit Windows PowerShell and Launch Windows Terminal from Start Menu. Then Run Install_Step2 to continue the setup.";

Write-Host -NoNewLine 'Press any key to continue..';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Exit
