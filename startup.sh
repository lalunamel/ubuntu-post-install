#!/bin/bash

# add repos
sudo add-apt-repository -y "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main"
sudo add-apt-repository -y "deb http://dl.google.com/linux/chrome/deb/ stable main"
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
sudo add-apt-repository -y ppa:webupd8team/java/ubuntu
sudo add-apt-repository -y ppa:freyja-dev/unity-tweak-tool-daily
sudo add-apt-repository -y ppa:fish-shell/release-2


# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

# configure home dir
rm -rf ~/Documents
rm -rf ~/Public
rm -rf ~/Templates
rm -rf ~/Videos
rm -rf ~/Music
mkdir ~/code
mkdir ~/bin

# install apps
sudo apt-get -y install \
    libxss1 sublime-text-installer git gitk gitg \
    dropbox \
    skype gimp p7zip p7zip-full p7zip-rar unity-tweak-tool \
    indicator-multiload curl gparted google-chrome-stable \
    nautilus-open-terminal linux-headers-generic \
    build-essential fish dconf-cli oracle-java7-installer
# install direnv
git clone https://github.com/direnv/direnv ~/bin/direnv
make -C ~/bin/direnv install

## configure terminal
# set fish as default shell
chsh -s `which fish`
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher # install fish pacakge manager
fisher edc/bass # install bass (run bash commands with fish, req for nvm)
# install solarized theme 
git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git ~/bin/gnome-terminal-colors-solarized
~/code/gnome-terminal-colors-solarized/install.sh
~/code/gnome-terminal-colors-solarized/set_dark.sh
# change font
gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Monaco 12"
gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font --type=boolean false

# install Node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash
nvm install node

# install Ruby
wget -O /tmp/chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf /tmp/chruby-0.3.9.tar.gz
sudo make -C /tmp/chruby-0.3.9 install

wget -O /tmp/chruby-fish-0.8.0.tar.gz https://github.com/JeanMertz/chruby-fish/archive/v0.8.0.tar.gz
tar -xzvf /tmp/chruby-fish-0.8.0.tar.gz
sudo make -C /tmp/chruby-fish-0.8.0 install

# config
ln -s ~/Dropbox/ubuntu-config/.config ~/.config

# fonts
ln -s ~/Dropbox/ubuntu-config/.fonts ~/.fonts

# requires clicks
sudo apt-get install -y ubuntu-restricted-extras

# prompt to install android studio and sdk
echo ""
echo ""
echo ""
echo "Download android studio and sdk"
echo "https://developer.android.com/studio/index.html"
echo ""
echo "Download nvidia drivers"
echo "http://www.nvidia.com/download/driverResults.aspx/77525/en-us"

# prompt for a reboot
echo ""
echo "===================="
echo " TIME FOR A REBOOT! "
echo "===================="
echo ""
