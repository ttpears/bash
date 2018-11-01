# Simple aliases
alias ll='ls -al'
alias la='ls -A'
alias l='ls -alF'
alias nano="nano -w"
alias grep="grep --color"

# Reload bash config
alias refresh='source ~/.bashrc'

# Show Mercurial log in less
alias hlog='hg log | less'

# Show verbose Mercurial log in less
alias hlogv='hg log -v | less'

# Show most recent changes in current Mercurial repo
alias showtip='hg export tip | colordiff | less -R'

# Remove unknown files from Mercurial repo
alias hgrmu="hg status -u | cut -d ' ' -f 2 | xargs rm"

# Remove "deleted" files from Mercurial repo
alias hgrmd="hg status -d | cut -d ' ' -f 2 | xargs hg rm"

# Print supported tmux colors
alias tcolors='for i in {0..255} ; do printf "\x1b[38;5;${i}mcolour${i}\n"; done'

# Reload Xresources (uxrvt settings)
alias xup='xrdb -merge ~/.Xresources'

# Allow rebasing in Mercurial repos
alias hgallow='hg phase --force --draft "outgoing() and public()"'
