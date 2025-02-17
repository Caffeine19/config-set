# blacklist for themes
ZSH_THEME_BLACKLIST=(
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
)

# if the current theme is in the blacklist, then load a random theme
if [[ " ${ZSH_THEME_BLACKLIST[@]} " =~ " ${RANDOM_THEME} " ]]; then
    echo "Theme is in the blacklist, loading another theme"
    theme
fi

# copy the current theme to the clipboard
copy_current_theme() {
    echo $RANDOM_THEME | pbcopy
}

# add the current theme to the blacklist
dislike_theme() {
    # add the current theme to the blacklist
    ZSH_THEME_BLACKLIST+=($RANDOM_THEME)
    # create the new list as a string
    local new_list=$(printf '"%s" ' "${ZSH_THEME_BLACKLIST[@]}")
    # update the .zshrc file, only matching the first occurrence
    sed -i '' "0,/^ZSH_THEME_BLACKLIST=(.*)/s//ZSH_THEME_BLACKLIST=($new_list)/" ~/.zshrc
    # load a random theme
    theme
}

echo "module theme.zsh loaded"
