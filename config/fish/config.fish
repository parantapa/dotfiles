set -x HOME_DOTFILES "$HOME/dotfiles"
set -x HOME_QUICKREFS "$HOME/quickrefs"
set -x HOME_SDOCS "$HOME/sdocs"

source "$HOME_DOTFILES/fishrc.d/basic.fish"
source "$HOME_DOTFILES/fishrc.d/dotfiles.fish"

source "$HOME_DOTFILES/fishrc.d/git-alias.fish"
source "$HOME_DOTFILES/fishrc.d/misc.fish"
# source "$HOME_DOTFILES/fishrc.d/lang-path.fish"
# source "$HOME_DOTFILES/bashrc.d/fab_completion.sh"

set -x _JAVA_OPTIONS "-Dawt.useSystemAAFontSettings=gasp -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# set -x PATH "$HOME_SDOCS/bin" $PATH
# set -x PATH "$HOME/bin" $PATH

# set -x NOTEBOOK_DIR "$HOME/workspace/notebooks"
# set -x PYTHONPATH "$HOME/workspace/py-modules"

# set -x CONDA_ROOT "$HOME/anaconda3"
# source "$CONDA_ROOT/etc/fish/conf.d/conda.fish"
# functions -e fish_right_prompt
# alias clear=/usr/bin/clear
