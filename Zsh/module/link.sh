# link all modules
for module in ~/Code/config-set/Zsh/module/*.zsh; do
    echo "linking $module"
    # link the module
    # https://github.com/ohmyzsh/ohmyzsh/wiki/Customization
    # the .zsh files in this dir will be auto loaded
    ln -s $module ~/.oh-my-zsh/custom/$(basename $module)
done
