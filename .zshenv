#####
# .zshenv
#
# fire@downgra.de
#
# $Id$
#####

# set various options
setopt                       \
        append_history       \
        auto_list            \
        auto_menu            \
        auto_param_keys      \
        auto_param_slash     \
        auto_pushd           \
        auto_remove_slash    \
        auto_resume          \
        autocd               \
        bad_pattern          \
        bang_hist            \
        correct              \
     NO_beep                 \
     NO_BG_NICE              \
     NO_NOMATCH              \
        complete_aliases     \
        equals               \
        extended_glob        \
        extended_history     \
        function_argzero     \
        glob                 \
     NO_glob_assign          \
        glob_complete        \
     NO_glob_dots            \
        glob_subst           \
        hash_cmds            \
        hash_dirs            \
        hash_list_all        \
        hist_allow_clobber   \
     NO_hist_beep            \
        hist_ignore_dups     \
        hist_ignore_space    \
        hist_reduce_blanks   \
     NO_hist_no_store        \
        hist_verify          \
     NO_hup                  \
     NO_inc_append_history   \
     NO_ignore_braces        \
     NO_ignore_eof           \
        interactive_comments \
     NO_list_ambiguous       \
     NO_list_beep            \
        list_types           \
        long_list_jobs       \
        magic_equal_subst    \
     NO_mail_warning         \
     NO_mark_dirs            \
     NO_menu_complete        \
        multios              \
        numeric_glob_sort    \
     NO_overstrike           \
        path_dirs            \
        posix_builtins       \
     NO_print_exit_value     \
     NO_prompt_cr            \
        prompt_subst         \
        pushd_ignore_dups    \
     NO_pushd_minus          \
        pushd_silent         \
        pushd_to_home        \
        rc_expand_param      \
     NO_rc_quotes            \
     NO_rm_star_silent       \
     NO_sh_file_expansion    \
        sh_option_letters    \
        short_loops          \
        share_history        \
     NO_sh_word_split        \
     NO_single_line_zle      \
     NO_sun_keyboard_hack    \
        unset                \
     NO_verbose              \
        notify               \
        mailwarning

# limits
ulimit -t unlimited  # cpu time (seconds)
ulimit -f unlimited  # file size (blocks)
ulimit -d unlimited  # data seg size (kbytes)
ulimit -s unlimited  # stack size (kbytes)
ulimit -c 0          # core file size (blocks)
ulimit -m unlimited  # resident set size (kbytes)
ulimit -u unlimited  # processe
ulimit -n unlimited  # file descriptors  (1024 ?)
ulimit -l unlimited  # locked-in-memory size (kb)
ulimit -v unlimited  # address space (kb)
ulimit -x unlimited  # file locks

# load config files
function load_config() {
    if [[ -f "$1" ]] {
        source "$1"
    }
}

export ZSHDIR=$HOME/.zsh

# load extra modules
autoload -U zmv
autoload -U run-help
autoload -U run-help-git
autoload -U run-help-svn
#

# set some other options
watch=notme
LOGCHECK=60
export WORDCHARS="."
#

# development stuff
export SVN_EDITOR='/home/fire/bin/svneditor'
#

# path setup
export PATH="$HOME/bin:$PATH"
export PYTHONPATH="$HOME/.python/"
#

# setup ssh keyagent
load_config $HOME/.keychain/$HOST-sh
#

