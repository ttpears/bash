# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
   if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
debian_chroot=$(cat /etc/debian_chroot)
   fi

# If this is an xterm set the title to user@host:dir
   case "$TERM" in
   xterm*|rxvt*)
   PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
   ;;
   *)
   ;;
   esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
   . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ];then
   . ~/.bash_functions
fi

if [ -f ~/.bash_work ];then
   . ~/.bash_work
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
   eval "`dircolors -b`"
   alias ls='ls --color=auto'
   alias dir='ls --color=auto --format=vertical'
   alias vdir='ls --color=auto --format=long'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
   . /etc/bash_completion
fi

# Customization

EDITOR=vim
BINPATH="/home/ttpearso/bin"
PATH="$PATH:$BINPATH"

# MySQL prompt so it shows hostname
export MYSQL_PS1="(\u@\h) [\d]> "
export HISTFILESIZE=3000

shopt -s histappend

if [ -f /home/`whoami`/docs/motd ]; then
   echo -e "\nPersonal MOTD Items:\n"
   cat /home/`whoami`/docs/motd
   echo
fi

function epoch2date () {
   date -d @$1
}
