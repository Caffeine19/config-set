# blacklist for themes
ZSH_THEME_BLACKLIST=(
    "apple"
    "agnoster"
    "arrow"
    "bureau"
    "fino-time"
    "fishy"
    "fox"
    "fwalch"
    "half-life"
    "mh"
    "minimal"
    "peepcode"
    "sporty_256"
    "sporty_256"
    "trapd00r"
    "linuxonly"
    "lambda"
    "darkblood"
    "fino"
    "steeef"
    "evan"
)

delete_theme_file_from_blacklist() {
    # the theme file is under $ZSH/themes/
    # and the name is like $ZSH/themes/$THEME_NAME.zsh-theme
    for theme_file in $ZSH/themes/*.zsh-theme; do
        # get the theme name from the file name
        local theme_name=$(basename $theme_file .zsh-theme)
        # check if the theme is in the blacklist
        if [[ " ${ZSH_THEME_BLACKLIST[@]} " =~ " $theme_name " ]]; then
            echo "delete theme file: $theme_file"
            # then delete the file in $ZSH/themes/
            rm $theme_file
        fi
    done
}

# copy the current theme to the clipboard
copy_current_theme() {
    echo -n "\"$RANDOM_THEME\"" | pbcopy
}

echo "[oh-my-zsh] module theme.zsh loaded"
