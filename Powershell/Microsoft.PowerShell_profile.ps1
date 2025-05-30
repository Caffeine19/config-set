oh-my-posh init pwsh --config 'C:\Users\93959\AppData\Local\Programs\oh-my-posh\themes\wopian.omp.json' | Invoke-Expression
#zsh | tokyo | emodipt-extend | mojada | 1_shell | wopian | ys | space | space-ship | tokyonight_storm

Import-Module posh-git
Import-Module Terminal-Icons
Set-PSReadLineOption -PredictionSource History
Set-PSReadlineKeyHandler -key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# Set-PSReadLineOption -EditMode Vi
# Set-PSReadlineOption -ViModeIndicator Cursor

# proxy 
function  SetProxy {
    Set-Variable https_proxy=http://127.0.0.1:7897
    Set-Variable http_proxy=http://127.0.0.1:7897

    Write-Host "Proxy has been set;"
    Write-Host "Run 'TestProxy' to test it;"
    Write-Host "Run 'RemoveProxy' to remove it;"
}

function  RemoveProxy {
    Remove-Variable -Name http_proxy
    Remove-Variable -Name https_proxy
    Write-Host "Proxy has been removed"
}
# proxy end

# alias for lazygit
Set-Alias -Name lg -Value lazygit

# alias for idea
Set-Alias -Name id -Value idea64.exe

# enable zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# enable fnm
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression