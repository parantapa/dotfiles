# Assume dotfiles exist

# Add dotfiles/bin to path
contains "$HOME/dotfiles/bin" $PATH
or set PATH "$HOME/dotfiles/bin" $PATH

# Add the pprint-data aliases
alias pq "pprint-data pickle"
alias yq "pprint-data yaml"
alias jqx "pprint-data json"
alias mq "pprint-data msgpack"
alias dq "pprint-data dset"
