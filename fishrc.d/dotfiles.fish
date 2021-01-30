# Assume dotfiles, quickrefs, and sdocs exist

# Add dotfiles/bin to path
set PATH "$HOME/dotfiles/bin" $PATH
set PATH "$HOME/dotfiles/cmd-compiled" $PATH

# Add the pprint-data aliases
alias pq "pprint-data pickle"
alias yq "pprint-data yaml"
alias jqx "pprint-data json"
alias mq "pprint-data msgpack"
alias dq "pprint-data dset"
