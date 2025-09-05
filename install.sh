#!/bin/bash

# 让脚本在任何命令失败时立即退出
set -e

# --- Helper Functions ---
# (可以放一些打印信息的辅助函数，让输出更好看)
info() {
    echo -e "\033[34m[信息]\033[0m $1"
}

success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

# 解析脚本所在目录，供 stow 使用
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- 1. 更新系统包列表 ---
info "更新软件包列表..."
sudo apt-get update

# --- 2. 安装核心命令行工具 ---
info "安装核心命令行工具（git、stow、curl、vim、zsh）..."
sudo apt-get install -y git stow curl vim zsh

# --- 2.1 创建常用目录 ---
info "在 $HOME 中创建常用目录（documents、downloads、projects、tmp、tools）..."
mkdir -p "$HOME/documents" "$HOME/downloads" "$HOME/projects" "$HOME/tmp" "$HOME/tools"

# --- 3. 安装 Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "正在安装 Oh My Zsh...，如果安装失败，请设置代理"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    info "已安装 Oh My Zsh。"
fi

# --- 3.1 安装常用 Oh My Zsh 插件 ---
ZSH_CUSTOM_DIR="$HOME/.oh-my-zsh/custom"
PLUG_AUTOSUGGESTIONS_DIR="$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
PLUG_SYNTAX_HL_DIR="$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"

if [ ! -d "$PLUG_AUTOSUGGESTIONS_DIR" ]; then
    info "安装插件：zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$PLUG_AUTOSUGGESTIONS_DIR"
else
    info "插件 zsh-autosuggestions 已安装。"
fi

if [ ! -d "$PLUG_SYNTAX_HL_DIR" ]; then
    info "安装插件：zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$PLUG_SYNTAX_HL_DIR"
else
    info "插件 zsh-syntax-highlighting 已安装。"
fi

# --- 4. 安装 Powerlevel10k 主题 ---
P10K_DIR="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    info "正在克隆 Powerlevel10k 主题..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    info "已安装 Powerlevel10k。"
fi

# --- 5. 安装 Nerd Fonts (用于 Powerlevel10k 的图标) ---
# 这是一个更复杂的步骤，可以先手动安装，以后再加入脚本
# 例如，下载并安装 Meslo Nerd Font
info "请手动安装 Nerd Font 以显示 Powerlevel10k 图标。"
info "例如：DejaVuSansM Nerd Font Mono"
info "下载地址： https://www.nerdfonts.com/font-downloads"

# --- 6. (可选) 安装其他你需要的软件 ---
# info "Installing other tools like htop, bat, fd-find..."
# sudo apt-get install -y htop bat fd-find
# # 注意：在 Ubuntu 上，bat 的可执行文件是 batcat，fd-find 是 fdfind
# # 你可能需要在 .zshrc 中为它们创建别名

# --- 7. 使用 GNU Stow 链接配置文件 ---
info "使用 stow 链接非 shell 配置（git、vim、tmux）..."
stow -v -t "$HOME" -d "$DOTFILES_DIR" git
stow -v -t "$HOME" -d "$DOTFILES_DIR" vim
stow -v -t "$HOME" -d "$DOTFILES_DIR" tmux

info "备份 ~/.zshrc 与 ~/.bashrc（如果存在）并链接 shell 配置..."
cp -a "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%s)" 2>/dev/null || true
cp -a "$HOME/.bashrc" "$HOME/.bashrc.bak.$(date +%s)" 2>/dev/null || true
rm -f "$HOME/.zshrc" "$HOME/.bashrc"

stow -v -t "$HOME" -d "$DOTFILES_DIR" zsh
stow -v -t "$HOME" -d "$DOTFILES_DIR" bash

# --- 7.1 抑制 P10K instant prompt 的控制台输出警告（可选：quiet）---
if [ -f "$HOME/.zshrc" ] && ! grep -q "POWERLEVEL9K_INSTANT_PROMPT" "$HOME/.zshrc"; then
    info "在 ~/.zshrc 顶部注入 'typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet'..."
    sed -i '1i typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet' "$HOME/.zshrc"
fi

# --- 8. 安装 Miniconda 到 $HOME/tools/miniconda3 ---
CONDA_DIR="$HOME/tools/miniconda3"
if [ ! -d "$CONDA_DIR" ]; then
    info "安装 Miniconda 到 $CONDA_DIR..."
    TMP_INSTALLER="$(mktemp -t miniconda-XXXXXXXX.sh)"
    curl -fsSL -o "$TMP_INSTALLER" https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash "$TMP_INSTALLER" -b -p "$CONDA_DIR"
    rm -f "$TMP_INSTALLER"
    # 初始化 zsh 以启用 conda 命令
    "$CONDA_DIR/bin/conda" init zsh || true
    info "禁用 conda 自动激活 base 环境..."
    conda config --set auto_activate_base false || true
else
    info "Miniconda 已安装：$CONDA_DIR"
fi

success "Installation script finished!"
info "后续步骤："
info "1. 将 Zsh 设为默认 shell：chsh -s \$(which zsh)"
info "2. Terminal font：DejaVuSansM Nerd Font Mono"
info "3. 重启终端或运行 'exec zsh' 使更改生效。"
info "VS Code/Cursor: 在设置中搜索 terminal default profile，将 Linux 默认配置设为 zsh；或在 settings.json 设置 terminal.integrated.defaultProfile.linux=zsh"
info "4. 如果仍有 IDE 自动注入 'conda activate base'，在设置中搜索 activateEnvironment，将 python.terminal.activateEnvironment 设为 false"


