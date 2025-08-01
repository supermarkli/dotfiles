#!/bin/bash

# 让脚本在任何命令失败时立即退出
set -e

# --- Helper Functions ---
# (可以放一些打印信息的辅助函数，让输出更好看)
info() {
    echo -e "\033[34m[INFO]\033[0m $1"
}

success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

# --- 1. 更新系统包列表 ---
info "Updating package lists..."
sudo apt-get update

# --- 2. 安装核心命令行工具 ---
info "Installing core command-line tools (git, stow, curl, vim, zsh)..."
sudo apt-get install -y git stow curl vim zsh

# --- 3. 安装 Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    # 使用非交互式方式运行安装脚本
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    info "Oh My Zsh is already installed."
fi

# --- 4. 安装 Powerlevel10k 主题 ---
P10K_DIR="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    info "Cloning Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    info "Powerlevel10k is already installed."
fi

# --- 5. 安装 Nerd Fonts (用于 Powerlevel10k 的图标) ---
# 这是一个更复杂的步骤，可以先手动安装，以后再加入脚本
# 例如，下载并安装 Meslo Nerd Font
info "Please install a Nerd Font manually for Powerlevel10k icons."
info "Visit: https://www.nerdfonts.com/font-downloads"

# --- 6. (可选) 安装其他你需要的软件 ---
# info "Installing other tools like htop, bat, fd-find..."
# sudo apt-get install -y htop bat fd-find
# # 注意：在 Ubuntu 上，bat 的可执行文件是 batcat，fd-find 是 fdfind
# # 你可能需要在 .zshrc 中为它们创建别名

success "Installation script finished!"
info "Next steps:"
info "1. Run 'stow .' in your dotfiles directory to link configs."
info "2. Set Zsh as your default shell: chsh -s \$(which zsh)"
info "3. Log out and log back in to apply all changes."
