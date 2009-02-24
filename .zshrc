#####
# .zshrc
#
# fire@downgra.de
#
# $Id$
#####

# set various options
setopt zle

#  eval $(/usr/bin/resize)

if [[ -d "$ZSHDIR" ]] {
    fpath=("$ZSHDIR/functions" $fpath)
    load_config "$ZSHDIR/dirhash"
    load_config "$ZSHDIR/functions/common"
    load_config "$ZSHDIR/alias"
    load_config "$ZSHDIR/abbrev_expansion"
    load_config "$ZSHDIR/bindkey"
    load_config "$ZSHDIR/completion"
    load_config "$ZSHDIR/virtualenvwrapper"
    load_config "$ZSHDIR/extensions"
    
    if [[ -f "$ZSHDIR/prompt" ]] {
        source "$ZSHDIR/prompt"
    } else {
        export PROMPT='%n@%m:%~$ '
    }
}
unfunction load_config

# some zsh tuning
HISTFILE=~/.zshhistory
HISTSIZE=8000
SAVEHIST=8000
REPORTTIME=5

# nice ls
eval $(dircolors -b)

# colored man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# set language
export LANG="en_US.utf8"
export LC_CTYPE="$LANG"

export OOO_FORCE_DESKTOP=gnome
