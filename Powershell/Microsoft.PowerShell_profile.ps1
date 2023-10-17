oh-my-posh init pwsh --config 'C:\Users\cafe-laptop\AppData\Local\Programs\oh-my-posh\themes\wopian.omp.json' | Invoke-Expression
#zsh | tokyo | emodipt-extend | mojada | 1_shell | wopian | ys | space

Import-Module posh-git
Import-Module Terminal-Icons
Set-PSReadLineOption -PredictionSource History
Set-PSReadlineKeyHandler -key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# Set-PSReadLineOption -EditMode Vi
# Set-PSReadlineOption -ViModeIndicator Cursor

function DevInit {
  Write-Host "DevInit"
 

  $shortcutPaths = @(
    "$env:USERPROFILE\Desktop\HBuilder X.lnk",
    "$env:USERPROFILE\Desktop\Visual Studio Code.lnk",
    "$env:USERPROFILE\Desktop\WPS Office.lnk",
    "$env:USERPROFILE\Desktop\gitkraken.lnk"
  )

  $shell = New-Object -ComObject WScript.Shell

  foreach ($shortcutPath in $shortcutPaths) {
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $targetPath = $shortcut.TargetPath
    Start-Process $targetPath
  }
}

function  OpenProxy{
  Set-Variable https_proxy=http://127.0.0.1:7890
  Set-Variable http_proxy=http://127.0.0.1:7890

  Write-Host "Proxy has been opened;"
  Write-Host "Run 'curl www.google.com' to test it;"
  Write-Host "Run 'CloseProxy' to close it"

}

function  CloseProxy{
  Remove-Variable -Name http_proxy
  Remove-Variable -Name https_proxy
  Write-Host "Proxy has been closed"
}

function TestProxy {
  Invoke-WebRequest "wwww.google.com"
  
}