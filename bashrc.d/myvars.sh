# Custom system specific variables
# NOTE: these variables are in lower case and not exported

MYVARS_FILE = "$HOME/.myvars.sh"

if [[ -r "$MYVARS_FILE" ]] ; then
    source "$MYVARS_FILE"
fi

edit-myvars () {
    $EDITOR "$MYVARS_FILE"
    source "$MYVARS_FILE"
}
alias emv=edit-myvars

show-myvars () {
    declare -p | \
    \grep -P '^declare\ \-\-\ [a-z]' | \
    sed -e 's/declare\ \-\-\ //'
}
alias smv="show-myvars"
