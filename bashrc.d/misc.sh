# Find alias
alias f="find-pdf"

# PDF viewer alias
e () {
    $PDFVIEWER "$@" >/dev/null 2>&1 &
}

# Pdflatex alias
alias xelatex="xelatex -file-line-error -halt-on-error"
alias pdflatex="pdflatex -file-line-error -halt-on-error"
