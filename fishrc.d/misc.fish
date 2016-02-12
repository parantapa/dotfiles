# Find alias
alias f "find-pdf"

# PDF viewer alias
function e
    eval runbg $PDFVIEWER $argv
end

# Pdflatex alias
alias xelatex "xelatex -file-line-error -halt-on-error"
alias pdflatex "pdflatex -file-line-error -halt-on-error"
