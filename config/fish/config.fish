set -x HOME_DOTFILES "$HOME/dotfiles"
set -x HOME_QUICKREFS "$HOME/quickrefs"
set -x HOME_SDOCS "$HOME/sdocs"

source "$HOME/dotfiles/fishrc.d/basic.fish"
source "$HOME/dotfiles/fishrc.d/dotfiles.fish"

source "$HOME/dotfiles/fishrc.d/git-alias.fish"
source "$HOME/dotfiles/fishrc.d/misc.fish"
source "$HOME/dotfiles/fishrc.d/runtime.fish"

if test -f "$HOME/edocs/fishrc.fish"
    source "$HOME/edocs/fishrc.fish"
end

# set -x PATH "$HOME/sdocs/bin" $PATH
# set -x PATH "$HOME/bin" $PATH

# set -x _JAVA_OPTIONS "-Dawt.useSystemAAFontSettings=gasp -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
# set -x PYTHONPATH "$HOME/workspace/labspace/py-modules/"

# functions -e fish_right_prompt
# alias clear=/usr/bin/clear

# alias px "pb calc"
