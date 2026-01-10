#!/usr/bin/bash
# dotfiles 链接管理脚本 (WSL 版)

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Linux 链接映射
declare -A LINK_MAP=(
    ["bash/.bashrc"]=".bashrc"
    ["zsh/.zshrc"]=".zshrc"
    ["zsh/.p10k.zsh"]=".p10k.zsh"
    ["vim/.vimrc"]=".vimrc"
    ["tmux/.tmux.conf"]=".tmux.conf"
    ["git/.gitconfig"]=".gitconfig"
    ["claude/CLAUDE.md"]=".claude/CLAUDE.md"
)

# 颜色输出
info() { echo -e "\033[34m[INFO]\033[0m $1"; }
success() { echo -e "\033[32m[OK]\033[0m $1"; }
error() { echo -e "\033[31m[ERROR]\033[0m $1"; }

link_files() {
    info "开始链接 Linux dotfiles..."
    for src in "${!LINK_MAP[@]}"; do
        dst_path="$HOME/${LINK_MAP[$src]}"
        src_path="$DOTFILES_DIR/$src"

        # 预检
        if [ ! -e "$src_path" ]; then
            error "跳过: 源文件 $src 不存在"
            continue
        fi

        mkdir -p "$(dirname "$dst_path")"
        
        # 备份非链接的现有文件
        if [ -e "$dst_path" ] && [ ! -L "$dst_path" ]; then
            backup="$dst_path.bak.$(date +%s)"
            mv "$dst_path" "$backup"
            info "已备份旧文件至 $backup"
        fi

        ln -sf "$src_path" "$dst_path"
        success "链接成功: ${LINK_MAP[$src]} → $src"
    done
}

# 执行
link_files
echo "--------------------------------"
success "所有配置同步完成！"