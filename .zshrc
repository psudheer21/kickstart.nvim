# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/zshrc.pre.zsh"
export HISTFILE="~/.zsh_history"
export HISTSIZE=200000
export SAVEHIST=200000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short

export AUTO_TITLE_SCREENS="NO"

# if you wish to use IMDS set AWS_EC2_METADATA_DISABLED=false
export AWS_EC2_METADATA_DISABLED=true

#export PROMPT="
#%{$fg[white]%}(%D %*) <%?> [%~] $program %{$fg[default]%}
#%{$fg[cyan]%}%m %#%{$fg[default]%} "

export PROMPT=$'| \e[0;31m%C\e[0m $ '
alias cls=clear

alias vi='nvim'
alias vim='nvim'

set-title() {
    echo -e "\e]0;$*\007"
}

setupTest() {
  export APOLLO_ENVIRONMENT_ROOT=$(brazil-path "[GroverPublicKeys]pkg.runtimefarm")
  echo "Second"
  export LD_LIBRARY_PATH="$(brazil-path run.runtimefarm)/lib"
  echo "Third"
  export LD_PRELOAD="$(brazil-path run.runtimefarm)/lib/libjemalloc-4k.so.2"
}

ssh() {
    set-title $*;
    /usr/bin/ssh -2 $*;
    set-title $HOST;
}

alias e=emacs
alias bb=brazil-build

alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
alias brc='brazil-recursive-cmd'
alias bws='brazil ws'
alias bwsuse='bws use -p'
alias bwscreate='bws create -n'
alias brc=brazil-recursive-cmd
alias bbr='brc brazil-build'
alias bball='brc --allPackages'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'


export PATH=$HOME/llvm-19/bin:$HOME/opt/bin:$HOME/bin:$PATH
export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.toolbox/bin:$PATH
source /home/sudheepo/.brazil_completion/zsh_completion
autoload -Uz compinit && compinit

# Set up mise for runtime management
eval "$(/home/sudheepo/.local/bin/mise activate zsh)"
source ~/.local/share/mise/completions.zsh
alias finch='sudo HOME=/home/sudheepo DOCKER_CONFIG=/home/sudheepo/.docker finch'

export BRAZIL_WORKSPACE_ROOT=/home/$USER/workplace/OscarGrover
alias mechanic='~/.toolbox/bin/mechanic'

function wscreate() {
    brazil ws create --name $1
    cd $1
    bws use -p GroverStorageNode
}

function ws()
{
    if [[ $# -eq 0 ]]; then
        cd /home/sudheepo/workplace/
        return
    fi

    cwd=$PWD;
    wspace="";
    if [[ "$cwd" == "/home/sudheepo/workplace/"* ]]; then
        wspace=$(echo $cwd | awk -F'/' '{print $5}')
    else
        wspace="OscarGrover"
    fi

    if [[ "$1" == "node" ]]; then
        cd /home/sudheepo/workplace/$wspace/src/GroverStorageNode
    fi

    if [[ "$1" == "cmn" ]]; then
        cd /home/sudheepo/workplace/$wspace/src/GroverStorageCommon
    fi

    if [[ "$1" == "svc" ]]; then
        cd /home/sudheepo/workplace/$wspace/src/GroverStorageNodeServiceModel
    fi

    if [[ "$1" == "base" ]]; then
        cd /home/sudheepo/workplace/$wspace/src/GroverBaseServiceModel
    fi

}
alias wsnode='ws node'
alias wscmn='ws cmn'
alias wssvc='ws svc'
alias wsbase='ws base'

function build() {
    cwd=$PWD;
    if [[ "$cwd" == *"GroverStorageNode"* ]]; then
        if [[ "$1" == "unit" ]]; then
            echo "Compiling only unit tests"
            bb build/private/dflt/grover/storage/unit-tests
            return
        fi

        if [[ "$1" == "api" ]]; then
            echo "Compiling only api tests"
            bb build/private/dflt/grover/storage/api-tests
            return
        fi

        if [[ "$1" == "bear" ]]; then
            bear -- brazil-build
            return
        fi

        echo "Compiling only GroverStorageNode"
        bb build
        return
    fi

    if [[ "$cwd" == *"GroverStorageCommon"* ]]; then
        if [[ "$1" == "bear" ]]; then
            bear -- brazil-build
            return
        fi

        echo "Compiling only GroverStorageCommon"
        brazil-build

        return
    fi

    echo "Compiling all packages"
    brazil-recursive-cmd brazil-build --allPackages
}


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/zshrc.post.zsh"

# Amazon instances
# PRivate IP : 172.31.47.131
alias dev2='ssh -i ~/sudheepoKeyPair1.pem ec2-user@ec2-52-91-223-45.compute-1.amazonaws.com'

# PRivate IP : 172.31.35.241
alias dev3='ssh -i ~/sudheepoKeyPair1.pem ec2-user@ec2-54-198-25-44.compute-1.amazonaws.com'







