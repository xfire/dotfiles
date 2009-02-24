# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If running interactively, then:
if [ "$PS1" ]; then

    # don't put duplicate lines in the history. See bash(1) for more options
    # export HISTCONTROL=ignoredups

    # enable color support of ls and also add handy aliases
    eval `dircolors -b`
    alias ls='ls --color=auto'
    alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    # some more ls aliases
    alias ll='ls -la'
    alias la='ls -lA'
    alias l='ls -CF'

    alias mutt="muttl"
    alias muttl="/usr/bin/mutt -F ~/.mutt/profiles/logitrack"
    alias muttp="/usr/bin/mutt -F ~/.mutt/profiles/paranetic"

    alias less="zless"

    alias vi="vim -i ~/.vim/viminfo"
    alias vim="vim -i ~/.vim/viminfo"
    alias ex="ex -i ~/.vim/viminfo"

    # set a fancy prompt
    #PS1='\u@\h:\w\$ '
    . ~/.prompt


    # If this is an xterm set the title to user@host:dir
    #case $TERM in
    #xterm*)
    #    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    #    ;;
    #*)
    #    ;;
    #esac

    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc).
    if [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi

    export PATH=$PATH:~/binw
    export PATH=$PATH:/workspace/apps/ant/bin
    export PATH=$PATH:/workspace/apps/maven/bin
   
    export LANG="de_DE"
    export LC_CTYPE=de_DE

    export CVS_RSH="ssh"
    export CVSROOT=":ext:slater:/var/lib/cvs"
    #export CVSROOT=":ext:burro.logi-track.com:/var/lib/cvs"

    keychain -q ~/.ssh/id_lt
    . ~/.keychain/`uname -n`-sh
fi
