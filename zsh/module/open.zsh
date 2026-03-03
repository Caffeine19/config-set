zo() {
    local dir=${1:-"."} # 如果没有传入参数，默认使用当前目录
    zi "$dir" && open ./
}

echo "[oh-my-zsh] module open.zsh loaded"
