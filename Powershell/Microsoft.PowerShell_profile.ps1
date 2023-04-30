oh-my-posh init pwsh --config 'C:\Users\cafe-laptop\AppData\Local\Programs\oh-my-posh\themes\wopian.omp.json' | Invoke-Expression
#zsh | tokyo | emodipt-extend | mojada | 1_shell | wopian | ys | space
Import-Module posh-git
Import-Module Terminal-Icons
Set-PSReadLineOption -PredictionSource History
Set-PSReadlineKeyHandler -key Tab -Function MenuComplete