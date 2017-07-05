export AWS_HOME=~/.aws

function agp {
    echo $AWS_DEFAULT_PROFILE
}

function asp {
    local rprompt=${RPROMPT/<aws:$(agp)>/}

    export AWS_DEFAULT_PROFILE=$1
    export AWS_PROFILE=$1

    export RPROMPT="<aws:$AWS_DEFAULT_PROFILE>$rprompt"
}

function aws_profiles {
    reply=($(grep profile $AWS_HOME/config|sed -e 's/.*profile \([a-zA-Z0-9_-]*\).*/\1/'))
}

compctl -K aws_profiles asp
source /usr/local/share/zsh/site-functions/_aws
