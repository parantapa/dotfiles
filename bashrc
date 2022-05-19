# ~/.bashrc: executed by bash(1) for non-login shells.

export HOME_DOTFILES="$HOME/dotfiles"
export HOME_QUICKREFS="$HOME/quickrefs"
export HOME_SDOCS="$HOME/sdocs"

source "$HOME/dotfiles/bashrc.d/basic.sh"
# source "$HOME/dotfiles/bashrc.d/myprompt.sh"
# source "$HOME/dotfiles/bashrc.d/git-alias.sh"

if [[ -r "$HOME/edocs/bashrc.sh" ]] ; then
    source "$HOME/edocs/bashrc.sh"
fi

pathadd "$HOME/dotfiles/bin"
# pathadd "$HOME/sdocs/bin"
# pathadd "$HOME/bin"

# export SQUEUE_FORMAT="%.10A %.15i %.9P %.45j %.8u %.2t %.10M %.6D %R"
# alias sq="squeue -u $USER"

# __pb_fzf_env="$HOME/miniconda3/envs/local"
# if [[ "$__pb_has_fzf" != "true" ]] ; then
#     __pb_has_fzf="true"
#     source "$__pb_fzf_env/share/fzf/shell/key-bindings.bash"
#     source "$__pb_fzf_env/share/fzf/shell/completion.bash"
# fi
