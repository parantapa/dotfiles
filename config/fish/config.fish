set -x HOME_DOTFILES "$HOME/dotfiles"
set -x HOME_QUICKREFS "$HOME/quickrefs"
set -x HOME_SDOCS "$HOME/sdocs"

source "$HOME_DOTFILES/fishrc.d/basic.fish"
source "$HOME_DOTFILES/fishrc.d/dotfiles.fish"

# source "$HOME_DOTFILES/bashrc.d/fab_completion.sh"
source "$HOME_DOTFILES/fishrc.d/git-alias.fish"
source "$HOME_DOTFILES/fishrc.d/misc.fish"

source "$HOME_DOTFILES/fishrc.d/kgp-proxies.fish"
source "$HOME_DOTFILES/fishrc.d/lang-path.fish"

source "$HOME_DOTFILES/fishrc.d/virtualfish-arch.fish"

set -x MY_SOUND_SYSTEM pulse
set -x _JAVA_OPTIONS "-Dawt.useSystemAAFontSettings=gasp -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

alias ssh-add-twitter-app "ssh-add $HOME_SDOCS/dotfiles-x/ssh-keys/labda-key-rsa"

set -x PATH "/home/parantapa/workspace/pypb/bin" $PATH
