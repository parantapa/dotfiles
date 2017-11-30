set -x HOME_DOTFILES "$HOME/dotfiles"
set -x HOME_QUICKREFS "$HOME/quickrefs"
set -x HOME_SDOCS "$HOME/sdocs"

source "$HOME_DOTFILES/fishrc.d/basic.fish"
source "$HOME_DOTFILES/fishrc.d/dotfiles.fish"

source "$HOME_DOTFILES/fishrc.d/git-alias.fish"
source "$HOME_DOTFILES/fishrc.d/misc.fish"
# source "$HOME_DOTFILES/fishrc.d/lang-path.fish"
# source "$HOME_DOTFILES/bashrc.d/fab_completion.sh"

set -x MY_SOUND_SYSTEM pulse
set -x _JAVA_OPTIONS "-Dawt.useSystemAAFontSettings=gasp -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# source "$HOME/anaconda3/etc/fish/conf.d/conda.fish"
#
# Do not use anaconda provided clear
# alias clear=/usr/bin/clear
#
# set VIRTUAL_ENV_DISABLE_PROMPT 1
