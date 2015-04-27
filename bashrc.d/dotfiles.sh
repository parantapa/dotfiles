# Assume dotfiles, quickrefs, and sdocs exist

# Add dotfiles/bin to path
pathadd "$HOME_DOTFILES/bin"
pathadd "$HOME_DOTFILES/cmd-compiled"

# Add the pprint-data aliases
alias pq="pprint-data pickle"
alias yq="pprint-data yaml"
alias jqx="pprint-data json"
alias mq="pprint-data msgpack"

alias pqi="prepl-data pickle"
alias yqi="prepl-data yaml"
alias jqi="prepl-data json"
alias mqi="prepl-data msgpack"

