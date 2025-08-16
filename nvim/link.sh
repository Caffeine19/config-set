# link idea vim
# Remove existing file/symlink if it exists
if [ -e ~/.ideavimrc ] || [ -L ~/.ideavimrc ]; then
    echo "Removing existing ~/.ideavimrc"
    rm ~/.ideavimrc
fi

# Create new symlink for ideavimrc
ln -s ~/Code/config-set/nvim/.ideavimrc ~/.ideavimrc
echo "Created symlink: ~/.ideavimrc -> ~/Code/config-set/nvim/.ideavimrc"

# link neo vim
# Remove existing directory/symlink if it exists
if [ -e ~/.config/nvim ] || [ -L ~/.config/nvim ]; then
    echo "Removing existing ~/.config/nvim"
    rm -rf ~/.config/nvim
fi

# Ensure parent directory exists
mkdir -p ~/.config

# Create new symlink for nvim config
ln -s ~/Code/config-set/nvim ~/.config/nvim
echo "Created symlink: ~/.config/nvim -> ~/Code/config-set/nvim"
