export CLICOLOR=1
export PATH=/usr/local/bin:$PATH
PATH=$PATH:/usr/local/sbin
PATH=$PATH:$HOME/bin

# no beep
setopt nolistbeep 
setopt no_beep

# aliases
alias ocaml='rlwrap ocaml'
alias smlsharp='rlwrap smlsharp'
alias diff='colordiff'
alias less='less -R'

alias sl='ls'
alias l='ls'
alias u='cd ..'
alias la='ls -al'
alias ll='ls -l'

# key settings(delete, home, end)
bindkey -e
bindkey "^?"    backward-delete-char
bindkey "^H"    backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# MacVim-KaoriYa Setting
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

# VCS settings
autoload -Uz vcs_info
precmd() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    psvar[1]=$vcs_info_msg_0_
}
PROMPT=$'%6F%n@%m%f %3F%~%f%1F%1v%f %# '

# rbenv setting
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# cabal PATH setting
PATH=$HOME/.cabal/bin:$PATH

# gvm settings
source $HOME/.gvm/bin/gvm-init.sh

autoload -U compinit
compinit 

# Use zsh-completions
fpath=(/Users/WK6/lib/zsh-completions $fpath)

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/WK6/.gvm/bin/gvm-init.sh" ]] && source "/Users/WK6/.gvm/bin/gvm-init.sh"
