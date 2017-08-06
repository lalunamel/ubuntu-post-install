#!/bin/bash

# based loosely on http://blog.self.li/post/74294988486/creating-a-post-installation-script-for-ubuntu
# last updated for Ubuntu 16.04.2

set -e

CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# disable prompts for apt-get
DEBIAN_FRONTEND=noninteractive

echo ""
echo ""
echo ""
echo "Dont leave yet! There are a few prompts along the way..."
echo ""
echo ""
echo ""

# add repos
sudo add-apt-repository -y "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main" # dropbox
sudo add-apt-repository -y "deb http://dl.google.com/linux/chrome/deb/ stable main" # chrome
sudo add-apt-repository -y ppa:webupd8team/java # oracle java
sudo add-apt-repository -y ppa:freyja-dev/unity-tweak-tool-daily # unity tweak tool
sudo add-apt-repository -y ppa:fish-shell/release-2 # fish shell
sudo add-apt-repository -y ppa:ubuntu-mate-dev/xenial-mate # mate-terminal (better styling than gnome terminal)
sudo apt-get update


# enable i386 support for installation of
sudo dpkg --add-architecture i386

# configure home dir
rm -rf ~/Documents
rm -rf ~/Public
rm -rf ~/Templates
rm -rf ~/Videos
rm -rf ~/Music
rm -rf ~/Pictures
rm -rf ~/examples.desktop
mkdir ~/code
mkdir ~/bin

# install apps
sudo apt-get -y --allow-unauthenticated install \
    libxss1 git gitk gitg \
    dropbox \
    p7zip p7zip-full p7zip-rar unity-tweak-tool \
    indicator-multiload curl gparted google-chrome-stable \
    linux-headers-generic \
    build-essential fish dconf-cli oracle-java8-installer direnv \
    lib32z1 lib32ncurses5 libbz2-1.0:i386 lib32stdc++6 \
    mate-terminal redshift-gtk


# remove default apps
sudo apt-get -y autoremove \
    gnome-calendar xterm \
    gnome-mahjongg gnome-mines gnome-sudoku \
    thunderbird libreoffice libreoffice-\* webbrowser-app

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

## configure terminal
# set fish as default shell
# https://fishshell.com/
chsh -s `which fish`
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher # install fish pacakge manager
fisher edc/bass # install bass (run bash commands with fish, req for nvm), TODO this line doesn't work
# install solarized theme
# https://github.com/oz123/solarized-mate-terminal
git clone https://github.com/oz123/solarized-mate-terminal.git ~/bin/mate-terminal-colors-solarized
~/bin/mate-terminal-colors-solarized/solarized-mate.sh
echo "Installed solarized theme to mate-terminal. You must select theme manually to apply it."
# enable alt left right word navigation
cp ./.inputrc ~/.inputrc

# install Node
# https://github.com/creationix/nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
nvm install node # TODO can't do this until terminal restart

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - # yarn instead of npm
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list # yarn instead of npm
sudo apt-get update
sudo apt-get install yarn

# install Ruby
# https://github.com/postmodern/chruby
wget -O /tmp/chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf /tmp/chruby-0.3.9.tar.gz -C /tmp/
sudo make -C /tmp/chruby-0.3.9 install
# https://github.com/JeanMertz/chruby-fish
wget -O /tmp/chruby-fish-0.8.0.tar.gz https://github.com/JeanMertz/chruby-fish/archive/v0.8.0.tar.gz
tar -xzvf /tmp/chruby-fish-0.8.0.tar.gz -C /tmp/
sudo make -C /tmp/chruby-fish-0.8.0 install

# screen dimming
gsettings set org.gnome.desktop.session idle-delay 3600 # screen will dim and lock after 1 hr

# copy config folder from dropbox
# TODO this doesn't work because the dropbox folder doesn't exist
# it just creates a file at ~/.config
# commented out: linking against the DB folder causes issues if using on multiple machines
# rm -rf ~/.config && ln -sf ~/Dropbox/ubuntu-config/.config ~/

# install fonts from dropbox
ln -s ~/Dropbox/ubuntu-config/.fonts ~/.fonts


# add unity launcher shortcuts
# TODO this doesn't work 
# failed to commit changes to dconf: GDBus.Errororg.grk.GDBus.UnmappedGError.Quark._g_2dfile_2dquark.Code4: Failed to create file '/home/cody/.config/dconf/user.JQUEWY': No such file or directory
gsettings set com.canonical.Unity.Launcher favorites "[\
'application://ubiquity.desktop', \
'application://google-chrome.desktop', \
'application://org.gnome.Nautilus.desktop', \
'application://atom.desktop', \
'application://mate-terminal.desktop', \
'unity://running-apps']"
# set each app to it's Super+num key
# TODO these don't work any more
python3 ./set_keyboard_shortcut.py 'GoogleChrome' 'google-chrome' '<Super>1'
python3 ./set_keyboard_shortcut.py 'Nautilus' 'nautilus' '<Super>2'
python3 ./set_keyboard_shortcut.py 'Atom' 'atom' '<Super>3'
python3 ./set_keyboard_shortcut.py 'Terminal' 'gnome-terminal' '<Super>4'

# auto-hide unity launcher
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-hide-mode 1 # this doesn't work for some reason
# do settings > appearance > behavior instead

# configure unity launcher by uninstalling desktop search scopes (e.g., searching amazon from the unity launcher)
# http://askubuntu.com/questions/362549/how-to-disable-all-scopes-filters-and-dash-plugins
sudo apt-get remove $(dpkg --get-selections | cut -f1 | grep -P "^unity-(lens|scope)-" | grep -vP "unity-(lens|scope)-(home|applications|files)" | tr "\n" " ")
# searching in the launcher only searches installed 
# TODO these don't work any more
gsettings set com.canonical.Unity.Lenses always-search "['applications.scope']"
gsettings set com.canonical.Unity.Dash scopes "['home.scope', 'applications.scope', 'files.scope']"
# disable dumb overlay scrollbars
gsettings set com.canonical.desktop.interface scrollbar-mode normal
# configure global keyboard shortcuts
# disable workspace stuff
# TODO this doesn't work. gsettings seems fucked
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up ""
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down ""
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left ""
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right ""
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up ""
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down ""
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left ""
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right ""

# set keyboard shortcuts so they're similar to mac

# disable activating a window's context menu (was super-space)
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "['disabled']"
# set open unity search with tapping Super + Space (holding will show keyboard help overlay)
dconf write /org/compiz/profiles/unity/plugins/unityshell/show-launcher "'<Super>space'"
# set open window action search with tapping Alt + Space
gsettings set org.compiz.integrated show-hud "['<Alt>space']"
# don't allow switching between the same type of application using alt tab (don't mix alt and tilde tab)
gsettings set org.compiz.profiles.unity.plugins.unityshell switch-strictly-between-applications "true"
# set switch all types of windows (alt tab) to super tab
gsettings set org.compiz.profiles.unity.plugins.unityshell alt-tab-forward "<Super>Tab"
gsettings set org.compiz.profiles.unity.plugins.unityshell alt-tab-prev "<Shift><Super>Tab"
# set switch currently focused window to super tilde
gsettings set org.compiz.profiles.unity.plugins.unityshell alt-tab-next-window "<Super>grave"
gsettings set org.compiz.profiles.unity.plugins.unityshell alt-tab-prev-window "<Shift><Super>asciitilde"


# configure indicator-multiload
# one of the colors doesn't get set if the duplicated lines are deleted
# loc are free, so w/e
gsettings set de.mh21.indicator-multiload.general autostart 'true'
gsettings set de.mh21.indicator-multiload.graphs.mem enabled 'true' # enable memory graph
gsettings set de.mh21.indicator-multiload.graphs.disk enabled 'true' # enable disk graph
gsettings set de.mh21.indicator-multiload.graphs.net enabled 'true' # enable network graph
gsettings set de.mh21.indicator-multiload.graphs.cpu enabled 'true' # enable network graph
gsettings set de.mh21.indicator-multiload.general background-color 'traditional:background'
gsettings set de.mh21.indicator-multiload.trace color 'traditional:cpu1'
gsettings set de.mh21.indicator-multiload.traces.load1 color 'traditional:load1'
gsettings set de.mh21.indicator-multiload.traces.cpu1 color 'traditional:cpu1'
gsettings set de.mh21.indicator-multiload.traces.cpu2 color 'traditional:cpu2'
gsettings set de.mh21.indicator-multiload.traces.cpu3 color 'traditional:cpu3'
gsettings set de.mh21.indicator-multiload.traces.cpu4 color 'traditional:cpu4'
gsettings set de.mh21.indicator-multiload.traces.disk2 color 'traditional:disk2'
gsettings set de.mh21.indicator-multiload.traces.disk1 color 'traditional:disk1'
gsettings set de.mh21.indicator-multiload.traces.net1 color 'traditional:net1'
gsettings set de.mh21.indicator-multiload.traces.net2 color 'traditional:net2'
gsettings set de.mh21.indicator-multiload.traces.net3 color 'traditional:net3'
gsettings set de.mh21.indicator-multiload.traces.swap1 color 'traditional:swap1'
gsettings set de.mh21.indicator-multiload.traces.mem1 color 'traditional:mem1'
gsettings set de.mh21.indicator-multiload.traces.mem2 color 'traditional:mem2'
gsettings set de.mh21.indicator-multiload.traces.mem3 color 'traditional:mem3'
gsettings set de.mh21.indicator-multiload.traces.mem4 color 'traditional:mem4'

# requires clicks
sudo apt-get install -y ubuntu-restricted-extras

# install android studio and sdk
echo ""
echo ""
echo ""
echo "Download android studio and sdk to `~/bin`!"
echo "https://developer.android.com/studio/index.html"
echo ""
echo "Install Nvidia drivers (this might break something major, so do it separately)"
echo "sudo add-apt-repository ppa:graphics-drivers/ppa"
echo "sudo apt-get install nvidia-367 or whatever is listed here: https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa"
echo ""
echo "Once dropbox finishes syncing, reload font cache"
echo "sudo fc-cache -fv"

echo "Don't forget to generate a new RSA key to upload to github!"

echo "To use ubutnu with an HDPI monitor, adjust your scaling settings in Display preferences"

# reboot
echo ""
echo "Reboot machine"
echo ""
