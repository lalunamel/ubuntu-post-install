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
    p7zip p7zip-full p7zip-rar unity-tweak-tool \
    indicator-multiload curl gparted \
    linux-headers-generic \
    build-essential fish dconf-cli oracle-java8-installer direnv \
    lib32z1 lib32ncurses5 libbz2-1.0:i386 lib32stdc++6 \
    vim \

# nice to have stuff
sudo apt-get install -y ubuntu-restricted-extras

# google chrome
firefox https://www.google.com/chrome/browser/desktop/index.html

# dropbox
firefox https://www.dropbox.com/install

# sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

# remove default apps
sudo apt-get -y autoremove \
    gnome-calendar xterm \
    gnome-mahjongg gnome-mines gnome-sudoku \
    thunderbird libreoffice libreoffice-\* webbrowser-app

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

# configure git
git config --global user.email 'cody.sehl@gmail.com'
git config --global user.name 'Cody Sehl'

## configure terminal
# set fish as default shell
# https://fishshell.com/
chsh -s `which fish`
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher # install fish pacakge manager

# install Node
# https://github.com/creationix/nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
fisher nvm # install nvm TODO can't do this until terminal restart

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
