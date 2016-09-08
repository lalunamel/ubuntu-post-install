#!/bin/bash

# based loosely on http://blog.self.li/post/74294988486/creating-a-post-installation-script-for-ubuntu
# last updated for Ubuntu 16.04

set -e

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
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3 # subl
sudo add-apt-repository -y ppa:webupd8team/java # oracle java
sudo add-apt-repository -y ppa:freyja-dev/unity-tweak-tool-daily # unity tweak tool
sudo add-apt-repository -y ppa:fish-shell/release-2 # fish shell

# enable i386 support for installation of
sudo dpkg --add-architecture i386

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

# configure home dir
rm -rf ~/Documents
rm -rf ~/Public
rm -rf ~/Templates
rm -rf ~/Videos
rm -rf ~/Music
rm -rf ~/Pictures
rm ~/examples.desktop
mkdir ~/code
mkdir ~/bin

# install apps
sudo apt-get -y --allow-unauthenticated install \
    libxss1 sublime-text-installer git gitk gitg \
    dropbox \
    p7zip p7zip-full p7zip-rar unity-tweak-tool \
    indicator-multiload curl gparted google-chrome-stable \
    linux-headers-generic \
    build-essential fish dconf-cli oracle-java8-installer direnv \
    lib32z1 lib32ncurses5 libbz2-1.0:i386 lib32stdc++6
    

# remove default apps
sudo apt-get -y autoremove \
    firefox gnome-calendar xterm \
    gnome-mahjongg gnome-mines gnome-sudoku \
    thunderbird libreoffice libreoffice-\* webbrowser-app

## configure terminal
# set fish as default shell
# https://fishshell.com/
chsh -s `which fish`
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher # install fish pacakge manager
fisher edc/bass # install bass (run bash commands with fish, req for nvm)
# install solarized theme 
# https://github.com/Anthony25/gnome-terminal-colors-solarized
git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git ~/bin/gnome-terminal-colors-solarized
~/bin/gnome-terminal-colors-solarized/install.sh --scheme dark
# enable alt left right word navigation
cp ./.inputrc ~/.inputrc

# install Node
# https://github.com/creationix/nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash
nvm install node

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

# config
rm -rf ~/.config && ln -sf ~/Dropbox/ubuntu-config/.config ~/

# fonts
ln -s ~/Dropbox/ubuntu-config/.fonts ~/.fonts


# add unity launcher shortcuts
# adding sublime doesn't work for some reason. must be added manually
gsettings set com.canonical.Unity.Launcher favorites "[\
'application://ubiquity.desktop', \
'application://google-chrome.desktop', \
'application://org.gnome.Nautilus.desktop', \
'application://sublime-text.desktop', \
'application://gnome-terminal.desktop', \
'unity://running-apps']"

# auto-hide unity launcher
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-hide-mode 1 # this doesn't work for some reason
# do settings > appearance > behavior instead

# configure unity launcher by uninstalling desktop search scopes (e.g., searching amazon from the unity launcher)
# http://askubuntu.com/questions/362549/how-to-disable-all-scopes-filters-and-dash-plugins
sudo apt-get remove $(dpkg --get-selections | cut -f1 | grep -P "^unity-(lens|scope)-" | grep -vP "unity-(lens|scope)-(home|applications|files)" | tr "\n" " ")
# searching in the launcher only searches installed applications
gsettings set com.canonical.Unity.Lenses always-search "['applications.scope']"
gsettings set com.canonical.Unity.Dash scopes "['home.scope', 'applications.scope', 'files.scope']"
# disable dumb overlay scrollbars
gsettings set com.canonical.desktop.interface scrollbar-mode normal
# configure global keyboard shortcuts
# disable workspace stuff
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up ""
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down ""
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left ""
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right ""
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up ""
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down ""
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left ""
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right ""
# set terminal to Ctrl+`
python3 ./set_keyboard_shortcut.py 'Terminal' 'gnome-terminal' '<Primary>grave'

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
echo "Download android studio and sdk"
echo "https://developer.android.com/studio/index.html"
echo ""
echo "Install Nvidia drivers (this might break something major, so do it separately)"
echo "sudo add-apt-repository ppa:graphics-drivers/ppa"
echo "sudo apt-get install nvidia-367 or whatever is listed here: https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa"
echo ""
echo "Once dropbox finishes syncing, reload font cache"
echo "sudo fc-cache -fv"

# reboot
echo ""
echo "Reboot machine"
echo ""
