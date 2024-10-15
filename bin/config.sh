#!/bin/bash

# Settings
_USER="i"
_GROUP="wheel"
_GROUPS="$_GROUP"
_HOME="/i/home"

_LANG="en_US.UTF-8"
_HOSTNAME="USB"
_TIMEZONE="/usr/share/zoneinfo/America/Belem"

# Language, locale and timezone
#cp /etc/locale.gen /etc/locale.gen.bckp
#echo "$_LANG UTF-8" > /etc/locale.gen
#ln -sf $_TIMEZONE /etc/localtime
#locale-gen
#echo "LANG=$_LANG" > /etc/locale.conf

# Kernel and Grub
sudo mkinitcpio -p linux

# Users, groups and Passwords
# It will complain about existing home. Worry not!
#useradd -m -d $_HOME -G $_GROUPS -s /bin/bash $_USER
#useradd -m -G $_GROUPS -s /bin/bash $_USER

#echo "Root password"
#passwd
#echo
#echo
#echo "$_USER password"
#passwd $_USER

# -------- Installation of Packages as root ---------

sudo pacman -S --noconfirm --needed $(cat pkg/pacman.txt)
yay         -S --noconfirm --needed $(cat pkg/aur.txt)
#pip    install        $(cat pkg/pip.txt)
#npm    install -g     $(cat pkg/npm.txt)
#gem    install        $(cat pkg/gem.txt)

# Services
#systemctl enable NetworkManager.service
#systemctl enable ntpd.service
#systemctl enable sshd.service

# Samba Settings
#echo "Samba Password"
#smbpasswd -a i
#systemctl enable smbd.service

# User Groups Settings
sudo gpasswd -a pedro uucp
sudo gpasswd -a pedro lock
sudo gpasswd -a pedro audio
sudo gpasswd -a pedro vboxusers

#chown $_USER:$_USER -R yaourt.sh pkg
#
#exportfs -arv
#systemctl enable nfs-server.service
