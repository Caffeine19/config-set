# link zshrc
# Remove existing file/symlink if it exists
if [ -e ~/.zshrc ] || [ -L ~/.zshrc ]; then
    echo "Removing existing ~/.zshrc"
    rm ~/.zshrc
fi

# Create new symlink
ln -s ~/Code/config-set/Zsh/Mac/MacBookProM2Max/.zshrc ~/.zshrc
echo "Created symlink: ~/.zshrc -> ~/Code/config-set/Zsh/Mac/MacBookProM2Max/.zshrc"
