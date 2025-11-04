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
alias oldvim='/usr/bin/vi'

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
export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.toolbox/bin:/apollo/env/EnvImprovement/bin:$PATH
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

function wsList() {
    counter=0
    directories=$(ls /home/sudheepo/workplace)

    for d in $directories; do
        ((counter++))
        echo "$counter $d"
    done

    read -p "Enter your selection: " selection
    echo $selection
    #x=$(echo $directories | awk -F ' ' '{print $'$selection'}')
    #return $x
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
    elif [[ "$cwd" == "/workplace/sudheepo/"* ]]; then
        wspace=$(echo $cwd | awk -F'/' '{print $4}')
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

    if [[ "$1" == "csd" ]]; then
        cd /home/sudheepo/workplace/$wspace/src/GroverCsd
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


alias sshSNDEV="GROVERCLUSTER=sn-dev /apollo/env/GroverTools/bin/SshToBastion --region us-east-1"
alias sshSNDEVPERF="GROVERCLUSTER=sn-dev-perf /apollo/env/GroverTools/bin/SshToBastion --region us-east-1"
alias sshDEVO="ssh -t grover-bastion-pre-prod-7001.iad7.amazon.com 'GROVERCLUSTER=devo /apollo/env/GroverTools/bin/SshToBastion'"
alias sshTEST="ssh -t grover-bastion-pre-prod-7001.iad7.amazon.com 'GROVERCLUSTER=test /apollo/env/GroverTools/bin/SshToBastion'"
alias sshINTEG="ssh -t grover-bastion-pre-prod-7001.iad7.amazon.com 'GROVERCLUSTER=integ /apollo/env/GroverTools/bin/SshToBastion'"
alias sshIAD="ssh -t grover-bastion-iad-25001.iad12.amazon.com 'GROVERCLUSTER=iad /apollo/env/GroverTools/bin/SshToBastion'"
alias sshIAD2="ssh -t grover-bastion-iad-25001.iad12.amazon.com 'GROVERCLUSTER=iad2 /apollo/env/GroverTools/bin/SshToBastion'"
alias sshPDX="ssh -t grover-bastion-pdx-64001.pdx4.amazon.com 'GROVERCLUSTER=pdx /apollo/env/GroverTools/bin/SshToBastion'"
alias sshDUB="ssh -t grover-bastion-dub-14001.dub4.amazon.com 'GROVERCLUSTER=dub /apollo/env/GroverTools/bin/SshToBastion'"
alias sshNRT="ssh -t grover-bastion-nrt-1b-i-122dc0b7.ap-northeast-1.amazon.com 'GROVERCLUSTER=nrt /apollo/env/GroverTools/bin/SshToBastion'"
alias sshSYD="ssh -t grover-bastion-syd-98001.syd7.amazon.com 'GROVERCLUSTER=syd /apollo/env/GroverTools/bin/SshToBastion'"
alias sshICN="ssh -t grover-bastion-icn-53001.icn53.amazon.com 'GROVERCLUSTER=icn /apollo/env/GroverTools/bin/SshToBastion'"
alias sshPreProd="ssh -t grover-bastion-pre-prod-7001.iad7.amazon.com"
alias sshProdIad="ssh -t grover-bastion-iad-25001.iad12.amazon.com"
alias sshProdPdx="ssh -t grover-bastion-pdx-64001.pdx4.amazon.com"
alias sshProdDub="ssh -t grover-bastion-dub-14001.dub4.amazon.com"

# getting the bastion : /apollo/env/envImprovement/bin/expand-hostclass GROVER-BASTION-IAD

alias getMetricStats='/workplace/sudheepo/OscarGrover/src/GroverStorageNodeTools/build/bin/get-metric-stats'


function MechDownload() {
    mechanic ex grover host download -r $1 -g $2 --id $3 --file-path-pattern "/apollo/env/GroverStorageNode/var/output/logs/application.log.2025-06-25-17*" --env-type STORAGENODE
}

function getWorkspace() {
    cwd=$PWD;
    if [[ "$cwd" == "/home/sudheepo/workplace/"* ]]; then
        echo $(echo $cwd | awk -F'/' '{print $5}')
    elif [[ "$cwd" == "/workplace/sudheepo/"* ]]; then
        echo $(echo $cwd | awk -F'/' '{print $4}')
    else
        echo "======"
    fi
}


function turtleCredentials() {
    export AWS_SHARED_CREDENTIALS_FILE=/apollo/env/TurtleRole_Ogit_DevDsk_PDX/var/credentials/129854102023/IntegTestTurtleOperationalRole/credentials
    sudo chmod 777 /apollo/env/TurtleRole_Ogit_DevDsk_PDX/var/credentials/129854102023/IntegTestTurtleOperationalRole/credentials
    ACCID=$1
    ROLE_OUTPUT=$(aws sts assume-role --role-arn arn:aws:iam::$ACCID:role/TimberLogFetchRole --role-session-name MySessionName)
    ACCESS_KEY=$(echo $ROLE_OUTPUT | jq -r '.Credentials.AccessKeyId')
    SECRET_KEY=$(echo $ROLE_OUTPUT | jq -r '.Credentials.SecretAccessKey')
    SESSION_TOKEN=$(echo $ROLE_OUTPUT | jq -r '.Credentials.SessionToken')

    cat > ./assumed_role_credentials << EOF
[default]
aws_access_key_id = ${ACCESS_KEY}
aws_secret_access_key = ${SECRET_KEY}
aws_session_token = ${SESSION_TOKEN}
EOF
    echo "Credentials file 'assumed_role_credentials' has been created"

    sudo chmod 777 ./assumed_role_credentials
}
export CLAUDE_MODEL_PROVIDER="bedrock"
export AWS_PROFILE="bedrock"
export AWS_REGION="us-west-2"
