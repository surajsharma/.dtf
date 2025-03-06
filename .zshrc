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

antigen theme kardan
antigen apply

# aliases
alias python="python3"
alias l="lsd"
alias ll="lsd -l"

#fzf
alias f="fd --type  f --hidden --exclude .git | fzf-tmux -p --reverse | xargs -o vim"


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
