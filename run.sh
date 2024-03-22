sudo=""
packet_manager=""
function install_brew(){
    if ![ command -v brew >/dev/null 2>&1 ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}
if [[ "$(uname)" == "Darwin" ]]; then
    echo "This is mac"
    install_brew
    packet_manager="brew"
    sudo=""
else
    packet_manager="apt"
    sudo="sudo"
fi
install_neovim=$sudo" "$packet_manager" install neovim"
$install_neovim
