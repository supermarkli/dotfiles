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

# 解析脚本所在目录，供 stow 使用
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- 1. 更新系统包列表 ---
info "Updating package lists..."
sudo apt-get update

# --- 2. 安装核心命令行工具 ---
info "Installing core command-line tools (git, stow, curl, vim, zsh)..."
sudo apt-get install -y git stow curl vim zsh

# --- 2.1 创建常用目录 ---
info "Creating common directories in $HOME (documents, downloads, projects, tmp, tools)..."
mkdir -p "$HOME/documents" "$HOME/downloads" "$HOME/projects" "$HOME/tmp" "$HOME/tools"

# --- 3. 安装 Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    # 使用非交互式方式运行安装脚本
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    info "Oh My Zsh is already installed."
fi

# --- 3.1 安装常用 Oh My Zsh 插件 ---
ZSH_CUSTOM_DIR="$HOME/.oh-my-zsh/custom"
PLUG_AUTOSUGGESTIONS_DIR="$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
PLUG_SYNTAX_HL_DIR="$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"

if [ ! -d "$PLUG_AUTOSUGGESTIONS_DIR" ]; then
    info "Installing plugin: zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$PLUG_AUTOSUGGESTIONS_DIR"
else
    info "Plugin zsh-autosuggestions is already installed."
fi

if [ ! -d "$PLUG_SYNTAX_HL_DIR" ]; then
    info "Installing plugin: zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$PLUG_SYNTAX_HL_DIR"
else
    info "Plugin zsh-syntax-highlighting is already installed."
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
info "For example, DejaVuSansM Nerd Font Mono"
info "Visit: https://www.nerdfonts.com/font-downloads"

# --- 6. (可选) 安装其他你需要的软件 ---
# info "Installing other tools like htop, bat, fd-find..."
# sudo apt-get install -y htop bat fd-find
# # 注意：在 Ubuntu 上，bat 的可执行文件是 batcat，fd-find 是 fdfind
# # 你可能需要在 .zshrc 中为它们创建别名

# --- 7. 使用 GNU Stow 链接配置文件 ---
info "Linking non-shell configs with stow (git, vim, tmux)..."
stow -v -t "$HOME" -d "$DOTFILES_DIR" git
stow -v -t "$HOME" -d "$DOTFILES_DIR" vim
stow -v -t "$HOME" -d "$DOTFILES_DIR" tmux

info "Backing up ~/.zshrc and ~/.bashrc (if present) and linking shell configs..."
cp -a "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%s)" 2>/dev/null || true
cp -a "$HOME/.bashrc" "$HOME/.bashrc.bak.$(date +%s)" 2>/dev/null || true
rm -f "$HOME/.zshrc" "$HOME/.bashrc"

stow -v -t "$HOME" -d "$DOTFILES_DIR" zsh
stow -v -t "$HOME" -d "$DOTFILES_DIR" bash

# --- 7.1 抑制 P10K instant prompt 的控制台输出警告（可选：quiet）---
if [ -f "$HOME/.zshrc" ] && ! grep -q "POWERLEVEL9K_INSTANT_PROMPT" "$HOME/.zshrc"; then
    info "Injecting 'typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet' at the top of ~/.zshrc..."
    sed -i '1i typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet' "$HOME/.zshrc"
fi

success "Installation script finished!"
info "Next steps:"
info "1. Set Zsh as your default shell: chsh -s \$(which zsh)"
info "2. Install a Nerd Font and select it in your terminal."
info "3. Restart terminal or run 'exec zsh' to apply all changes."
info "VS Code/Cursor: 在设置中搜索 terminal default profile，将 Linux 默认配置设为 zsh；或在 settings.json 设置 terminal.integrated.defaultProfile.linux=zsh"

