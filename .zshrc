# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/suraj/.zshrc'


autoload -Uz compinit
compinit

source $HOME/.zshenv


# ANTIGEN
source /usr/local/share/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
    fzf
    git
    pip
    command-not-found
    z
    emoji
    colored-man-pages
    therzka/zemoji
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
EOBUNDLES

antigen theme geometry-zsh/geometry
GEOMETRY_INFO=''

antigen apply

#fzf
alias f="fd --type f --follow --hidden --exclude .git | fzf-tmux -p --reverse | xargs -o nvim"


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/suraj/.opam/opam-init/init.zsh' ]] || source '/home/suraj/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

export PATH=~/.cargo/bin/:$PATH
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:~/.local/bin

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/suraj/demtech/google-cloud-sdk/path.zsh.inc' ]; then . '/home/suraj/demtech/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/suraj/demtech/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/suraj/demtech/google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/home/suraj/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end




# aliases
# docker server (daemon)
alias d='sudo nohup dockerd > /dev/null 2>&1 &'
alias dstop='sudo pkill dockerd'

# general
alias python="python3"
alias l="lsd"
alias ll="lsd -l"

# networking
alias pgbridge='sudo nohup socat TCP-LISTEN:15432,fork TCP:localhost:5432 > /dev/null 2>&1 &'
alias pgfwd='nohup kubectl port-forward pod/stg-postgresql-0 -n postgresql 5432:5432 > /dev/null 2>&1 &'
alias pgfwd-stop="sudo pkill -f 'kubectl port-forward pod/stg-postgresql-0'"
