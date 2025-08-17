# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# FZF configuration (add before antigen section)
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --no-border
  --inline-info
  --preview-window=:hidden
  --bind='ctrl-/:toggle-preview'
  --color='bg+:-1,bg:-1,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672'
"

# Ctrl+R specific options (history search)
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window down:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'Press CTRL-Y to copy command into clipboard'
"

# Ctrl+T specific options (file search)
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# Alt+C specific options (directory navigation)
export FZF_ALT_C_OPTS="
  --preview 'lsd --tree --color=always {} | head -200'
"

autoload -Uz compinit
compinit


# ANTIGEN
source ~/.nix-profile/share/antigen/antigen.zsh

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

export PATH=~/.cargo/bin/:$PATH
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:~/.local/bin

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
alias x="exit && exit"

# networking

export PG=stg-postgresql-0
set_pg() {
  local pg="$1"
  if [[ -z "$pg" ]]; then
    echo "❌ Usage: set_pg <pg>"
    return 1
  fi
  sed -i'' "s/^export PG=.*/export PG=${port}/" ~/.zshrc
  export PG="$PG"
  echo "✅ PG updated to $1"
}


export ST=supertokens-core-6554fbcd45-qbzdk
set_st() {
  local st="$1"
  if [[ -z "$st" ]]; then
    echo "❌ Usage: set_pg <pg>"
    return 1
  fi
  sed -i'' "s/^export ST=.*/export ST=${st}/" ~/.zshrc
  export ST="$st"
  echo "✅ ST updated to $1"
}


#socat bridges
alias pgbridge='sudo nohup socat TCP-LISTEN:15432,fork TCP:localhost:5432 > /tmp/socat.log 2>&1 &!'
alias stbridge='sudo nohup socat TCP-LISTEN:13567,fork TCP:localhost:3567 > /tmp/socat.log 2>&1 &!'
alias scatkill="sudo pkill -f '^socat TCP-LISTEN:' && echo '🛑 All socat bridges stopped.'"
alias scat="ps aux | grep '[s]ocat TCP-LISTEN:'"

#kubectl port-forwarding
alias pgpf='nohup kubectl port-forward pod/$PG -n postgresql 5432:5432 > /dev/null 2>&1 &'
alias stpf='nohup kubectl port-forward pod/$ST 3567:3567 > /dev/null 2>&1 &'
alias stpfx="sudo pkill -f 'kubectl port-forward pod/$ST'"
alias pgpfx="sudo pkill -f 'kubectl port-forward pod/$PG'"
alias pfkill="sudo pkill -f '^kubectl port-forward' && echo '🛑 All kubectl port-forwards stopped.'"
alias pf="ps aux | grep '[k]ubectl port-forward'"

##random 
alias recent='pkill -f anna.sh; nohup ~/anna.sh >/dev/null 2>&1 & disown;' 
alias rc='tail -f ~/annas_recent.log | awk '\''/^===/ {print; next} /^\[/ {p=1} p; /^\]/ {p=0}'\'' | grep -v "^===" | jq'

# Start Docker daemon if not running
alias docd="sudo pgrep dockerd > /dev/null || (nohup sudo dockerd > /dev/null 2>&1 &)"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
alias count='find . -name "*.md" ! -name "index.md" -exec wc -w {} +'
