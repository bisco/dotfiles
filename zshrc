#users generic .zshrc file for zsh(1)

## Environment variable configuration
#
# LANG
#

export TERM=xterm-256color

#export LANG=ja_JP.UTF-8
#xset -b
#setopt brace_ccl

export PATH=$HOME/.bin:$HOME/.local/bin:$HOME/.cargo/bin/:$PATH
if [[ "${OSTYPE}" == darwin* ]]; then
# 何もしない
else
    export DISPLAY=`echo $SSH_CONNECTION | perl -lane 'print $F[0]'`:0.0
fi

# node.js
# export PATH=$HOME/.bin/node/bin:$PATH
# export NODE_PATH=$HOME/.bin/node/lib/node_modules

# anaconda
# export PATH=$HOME/.bin/anaconda/bin:$PATH
# export DYLD_FALLBACK_LIBRARY_PATH=$HOME/.bin/anaconda/lib:/usr/local/lib:/usr/lib

# Golang
# export GOPATH=$HOME/work/go
# export GOROOT=$HOME/go
# export PATH=$GOROOT/bin:$PATH

# snap
# export PATH=/snap/bin:$PATH

# alias
alias less="less -x4"
alias tmux="tmux -2"

# less source-highlight
export LESS=' -R'
export LESSOPEN='| src-hilite-lesspipe.sh %s'

#-------------------------------------------#
# Default shell configuration
#-------------------------------------------#
# set prompt
setopt prompt_subst
autoload -U colors; colors

# get branch name and hash
function branch-status-check {
    local prefix branchname suffix
    # .gitの中だから除外
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    branchname=`get-branch-name`
    # ブランチ名が無いので除外
    if [[ -z $branchname ]]; then
        return
    fi
    shorthash=`get-branch-hash`
    prefix=`get-branch-status` #色だけ返ってくる
    suffix='%{'${reset_color}'%}'
    echo ${prefix}${branchname}\(${shorthash}\)${suffix}
}

function get-branch-name {
    # gitディレクトリじゃない場合のエラーは捨てます
    echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}

function get-branch-status {
    local res color
    output=`git status --short 2> /dev/null`
    if [ -z "$output" ]; then
        res=':' # status Clean
        color='%{'${fg[green]}'%}'
    elif [[ $output =~ "[\n]?\?\? " ]]; then
        res='?:' # Untracked
        color='%{'${fg[yellow]}'%}'
    elif [[ $output =~ "[\n]? M " ]]; then
        res='M:' # Modified
        color='%{'${fg[red]}'%}'
    else
        res='A:' # Added to commit
        color='%{'${fg[cyan]}'%}'
    fi
    # echo ${color}${res}'%{'${reset_color}'%}'
    echo ${color} # 色だけ返す
}

function get-branch-hash {
    echo `git rev-parse --short HEAD 2> /dev/null`
}

# nix-direnv がロードされているときに [nix] を表示する関数
function nix-indicator {
    if [[ -n "${IN_NIX_SHELL}" ]]; then
      echo "%F{075}[nix]%f "
    fi
}

if [ ${TERM} != "dumb" ] ; then
    case ${UID} in
    0)
        PROMPT="%B%{${fg[magenta]}%}%/"$'\n'"#%{${reset_color}%}%b "
        PROMPT2="%B%{${fg[magenta]}%}%_#%{${reset_color}%}%b "
        SPROMPT="%B%{${fg[magenta]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="%{${fg[red]}%}$(whoami)"@"$(echo ${HOST%%.*}) ${PROMPT}"
        ;;
    *)
        PROMPT="%F{cyan}%/ %f"$'`nix-indicator`'$'`branch-status-check`'$'\n'"%F{cyan}>%f "

        PROMPT2="%F{cyan}%_%f> "
        SPROMPT="%F{cyan}%r is correct? [n,y,a,e]:%f "
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="%F{yellow}$(whoami)@$(echo ${HOST%%.*}) ${PROMPT}"
        ;;
    esac
else
    case ${UID} in
    0)
        PROMPT="%B%{%}%/#%{%}%b "
        PROMPT2="%B%{%}%_#%{%}%b "
        SPROMPT="%B%{%}%r is correct? [n,y,a,e]:%{%}%b "
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
        ;;
    *)
        PROMPT="%{%}%/%%%{%} "
        PROMPT2="%{%}%_%%%{%} "
        SPROMPT="%{%}%r is correct? [n,y,a,e]:%{%} "
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
        ;;
    esac
fi



# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep


## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes 
#   to end of it)
#
bindkey -e


# historical backward/forward search with linehead string binded to ^P/^N
#
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end


## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data


## Completion configuration
#
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -U compinit; compinit


## zsh editor
#
autoload -U zed


## Prediction configuration
#
#autoload predict-on
#predict-off


## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
    freebsd*|darwin*)
        alias ls="ls -G -w"
        ;;
    linux*|msys)
        alias ls="ls --color"
        ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

alias du="du -h"
alias df="df -h"

alias su="su -l"

case "${OSTYPE}" in
    darwin*)
        alias updateports="sudo port selfupdate; sudo port outdated"
        alias portupgrade="sudo port upgrade installed"
        ;;
    freebsd*)
    case ${UID} in
        0)
            updateports() 
            {
                if [ -f /usr/ports/.portsnap.INDEX ]
                then
                    portsnap fetch update
                else
                    portsnap fetch extract update
                fi

                (cd /usr/ports/; make index)

                portversion -v -l \<
            }
            alias appsupgrade='pkgdb -F && BATCH=YES NO_CHECKSUM=YES portupgrade -a'
            ;;
    esac
    ;;
esac



## terminal configuration
case "${TERM}" in
    xterm|xterm-256color|screen)
        export LSCOLORS=gxfxcxdxbxegedabagacad
        export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
        zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
        ;;
    kterm-color)
        stty erase '^H'
        export LSCOLORS=gxfxcxdxbxegedabagacad
        export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
        zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
        ;;
    kterm)
        stty erase '^H'
        ;;
    cons25)
        unset LANG
        export LSCOLORS=ExFxCxdxBxegedabagacad
        export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
        zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
        ;;
    jfbterm-color)
        export LSCOLORS=gxFxCxdxBxegedabagacad
        export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
        zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
        ;;
esac




## load user .zshrc configuration file
#
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

# set terminal title including current directory
case "${TERM}" in
    kterm*|xterm*)
        precmd() {
            echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
        }
        ;;
esac

if [ "$TERM" = "screen" ]; then
    chpwd() { echo -n "_`dirs`\\" }
    preexec() {
        emulate -L zsh
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
        fg)
            if (( $#cmd == 1 )); then
                cmd = (builtin jobs -l %+)
            else
                cmd = (builtin jobs -l $cmd[2])
            fi
            ;;
        %*)
            cmd = (builtin jobs -l $cmd[1])
            ;;
        cd)
            if (( $#cmd == 2 )); then
                cmd[1] = $cmd[2]
            fi
            ;&
        *)
            echo -n "k$cmd[1]:t\\"
            return
            ;;
        esac
        local -A jt; jt=(${(kv)jobtexts})

        $cmd >>(read num rest
        cmd=(${(z)${(e):-\$jt$num}})
        echo -n "k$cmd[1]:t\\") 2> /dev/null
    }
    chpwd
fi

if [ "$EMACS" ];then
    export TERM=xterm-color
fi
eval "$(/home/bisco/.local/bin/mise activate zsh)"
eval "$(direnv hook zsh)"
