# link zshrc
# Remove existing file/symlink if it exists
if [ -e ~/.zshrc ] || [ -L ~/.zshrc ]; then
    echo "Removing existing ~/.zshrc"
    rm ~/.zshrc
fi

# Create new symlink
ln -s ~/Code/config-set/Zsh/Mac/MacBookAirM3/.zshrc ~/.zshrc
echo "Created symlink: ~/.zshrc -> ~/Code/config-set/Zsh/Mac/MacBookAirM3/.zshrc"
