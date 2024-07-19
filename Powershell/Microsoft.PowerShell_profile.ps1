oh-my-posh init pwsh --config 'C:\Users\93959\AppData\Local\Programs\oh-my-posh\themes\tokyonight_storm.omp.json' | Invoke-Expression
#zsh | tokyo | emodipt-extend | mojada | 1_shell | wopian | ys | space | space-ship | tokyonight_storm

Import-Module posh-git
Import-Module Terminal-Icons
Set-PSReadLineOption -PredictionSource History
Set-PSReadlineKeyHandler -key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# Set-PSReadLineOption -EditMode Vi
# Set-PSReadlineOption -ViModeIndicator Cursor

function  SetProxy {
    Set-Variable https_proxy=http://127.0.0.1:7890
    Set-Variable http_proxy=http://127.0.0.1:7890

    Write-Host "Proxy has been set;"
    Write-Host "Run 'TestProxy' to test it;"
    Write-Host "Run 'RemoveProxy' to remove it;"
}

function  RemoveProxy {
    Remove-Variable -Name http_proxy
    Remove-Variable -Name https_proxy
    Write-Host "Proxy has been removed"
}

# enable zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })