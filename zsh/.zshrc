# 为 Powerlevel10k 的 gitstatus 组件指定临时文件目录
export GITSTATUS_CACHE_DIR="$HOME/tmp/gitstatus"
# 将临时文件目录指向/home/lzh/tmp
export TMPDIR=~/tmp
export TMP=~/tmp
export TEMP=~/tmp

# 启用 Powerlevel10k 即时提示。此部分应保持在 ~/.zshrc 文件的顶部附近。
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh 的安装路径。
export ZSH="$HOME/.oh-my-zsh"

# 设置要加载的主题名称。
# 更多主题请参考: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# 设置需要加载的插件。
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# 加载 Oh My Zsh。
source $ZSH/oh-my-zsh.sh

# 如果要自定义提示符，请运行 `p10k configure` 或编辑 ~/.p10k.zsh 文件。
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



# 修复 Conda 与 OpenSSL 3.0 的兼容性问题
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

# NVM (Node Version Manager) 的配置
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # 加载 nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # 加载 nvm 的 bash 自动补全
export TERMINFO=/usr/lib/terminfo

# >>> conda initialize >>>
# !! 下方区块中的内容由 'conda init' 管理，请勿手动修改 !!
__conda_setup="$('/home/lzh/tools/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/lzh/tools/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/lzh/tools/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/lzh/tools/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda activate base >/dev/null 2>&1


