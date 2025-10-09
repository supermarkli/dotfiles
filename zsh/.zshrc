# ===== 用户自定义变量（集中管理） =====
# Powerlevel10k gitstatus 缓存目录
export GITSTATUS_CACHE_DIR="$HOME/tmp/gitstatus"
# 临时目录
export TMPDIR=~/tmp
export TMP=~/tmp
export TEMP=~/tmp
# Oh My Zsh 安装路径
export ZSH="$HOME/.oh-my-zsh"
# NVM 根目录
export NVM_DIR="$HOME/.nvm"
# 终端 terminfo 数据库位置
export TERMINFO=/usr/lib/terminfo
# 修复 Conda 与 OpenSSL 3.0 的兼容性问题
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
# Conda 安装根路径（可通过预先导出 CONDA_HOME 覆盖默认值）
export CONDA_HOME="${CONDA_HOME:-$HOME/tools/miniforge3}"

export PATH=/usr/local/cuda/bin:$PATH

# 启用 Powerlevel10k 即时提示。此部分应保持在 ~/.zshrc 文件的顶部附近。
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh 的安装路径。

# 设置要加载的主题名称。
# 更多主题请参考: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# 设置需要加载的插件。
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# 加载 Oh My Zsh。
source $ZSH/oh-my-zsh.sh

# 如果要自定义提示符，请运行 `p10k configure` 或编辑 ~/.p10k.zsh 文件。
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# NVM (Node Version Manager) 的配置
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # 加载 nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # 加载 nvm 的 bash 自动补全
 

# 自定义别名
alias c='clear'

# >>> conda initialize >>>
# !! 下方区块中的内容由 'conda init' 管理，请勿手动修改 !!
__conda_setup="$("$CONDA_HOME/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_HOME/etc/profile.d/conda.sh" ]; then
        . "$CONDA_HOME/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_HOME/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda activate base >/dev/null 2>&1

