# Proxy configuration
PROXY_HTTP_PORT=6152
PROXY_SOCKS_PORT=6153

set_proxy() {
    export http_proxy="http://127.0.0.1:${PROXY_HTTP_PORT}"
    export https_proxy="http://127.0.0.1:${PROXY_HTTP_PORT}"
    export all_proxy="socks5://127.0.0.1:${PROXY_SOCKS_PORT}"

}

unset_proxy() {
    unset http_proxy https_proxy all_proxy
    echo "Proxy unset"
}

test_proxy() {
    echo "http_proxy  = ${http_proxy:-<not set>}"
    echo "https_proxy = ${https_proxy:-<not set>}"
    echo "all_proxy   = ${all_proxy:-<not set>}"
    echo ""
    curl "www.google.com" && (echo "" && echo "" && echo "Proxy is working") || (echo "" && echo "" && echo "Proxy is NOT working")
}

# Auto-enable proxy on shell startup
set_proxy

echo "[oh-my-zsh] module proxy.zsh loaded"
