# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# history 
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="$HOME/.zsh_history"
setopt INC_APPEND_HISTORY
# export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

# setopt AUTO_CD
setopt CORRECT

setopt INTERACTIVE_COMMENTS

setopt TRANSIENT_RPROMPT

# shellcheck disabl=SC1090
include() {
    for p in "$@"; do
        if [[ -f "$p" ]]; then
            source "$p"
            break
        fi
    done
}

# shellcheck disabl=SC1090
include_arg() {
    [[ -f "$1" ]] && source "$1" "${@:1}"
}

check_bin() {
    local _full_path
    _full_path=$(command -v "$1")
}

typeset -U path # unique
path=(
    ~/.local/bin
    ~/.cargo/bin
    ~/.nix-profile/bin
    $path
)

check_bin nvim && export EDITOR="nvim"
check_bin bat && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

alias ls='ls --color=tty'

check_bin exa && alias l='exa -lah --icons --git --color-scale' || alias l='ls -lAh'
alias ll='ls -lh'
alias la='ls -lAh'

alias sudo='sudo '
alias rm='rm --interactive=always'
check_bin ranger && alias ra='ranger'

if [ -z "$TMUX" ]
then
    alias c='clear'
else
    alias c='clear && tmux clear-history'
fi

alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'

alias ..='cd ..'


# ref: https://wiki.archlinux.org/title/zsh
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Ctrl-Left]="${terminfo[kLFT5]}"
key[Ctrl-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Home]}"            ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"             ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"          ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}"       ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"          ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"              ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"            ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"            ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"           ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"          ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"        ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Ctrl-Left]}"       ]] && bindkey -- "${key[Ctrl-Left]}"  backward-word
[[ -n "${key[Ctrl-Right]}"      ]] && bindkey -- "${key[Ctrl-Right]}" forward-word

bindkey '^Q'    push-line-or-edit # ^Q might not work in konsole, do disable flow control in konsole first


if [[ ${$(cat /proc/version)[3]} =~ -Microsoft$ ]]; then
    ## workaround for WSL1
    # commit https://gitlab.com/psmisc/psmisc/-/commit/b085f2f4ace1aa2f2897a53ea1935853d583dcef does not work on WSL1
    # function killall() { command ~/.local/bin/killall $* }
    # Requires: https://sourceforge.net/projects/vcxsrv/
    export DISPLAY=:0.0
    # export LIBGL_ALWAYS_INDIRECT=1
    # https://dailydoseoftech.com/solved-rsync-hangs-during-sync-on-wsl/
    # https://github.com/microsoft/WSL/issues/2138
    # alias rsync='{sleep 1 && while (killall -CHLD ssh && killall -CHLD rsync) {sleep 0.1;} }& ; rsync '
    function rsync() {
        {sleep 1 && while (killall -CHLD ssh && killall -CHLD rsync) {sleep 0.1;} }&;
        command rsync $*
        fg
    }
    # TODO https://github.com/microsoft/WSL/issues/8356
    # https://github.com/microsoft/WSL/issues/8151
    # function node() { command /lib64/ld-linux-x86-64.so.2 /usr/bin/node $* }
fi

function ranger() {
    if [ -z "$RANGER_LEVEL" ]
    then
        command ranger $*
    else
        exit
    fi
}


## https://github.com/zsh-users/zsh-completions.git
fpath=(~/.local/share/zsh-completions/src $fpath)
autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
compdef watch=command
compdef proxychains=command

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

for plg in {/usr,~/.local}/share/zsh/plugins/*/*.plugin.zsh(N); do
    source $plg
done

#include {/usr,~/.local}/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


check_bin starship && eval "$(starship init zsh)"
