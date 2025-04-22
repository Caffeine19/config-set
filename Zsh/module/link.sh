# link all modules
for module in ~/Code/config-set/Zsh/module/*.zsh; do
    # check if the link already exists
    if [ -L ~/.oh-my-zsh/custom/$(basename $module) ]; then
        echo "link already exists, skipping $module"
        continue
    fi

    echo "linking $module"
    # link the module
    # https://github.com/ohmyzsh/ohmyzsh/wiki/Customization
    # the .zsh files in this dir will be auto loaded
    ln -s $module ~/.oh-my-zsh/custom/$(basename $module)
done
