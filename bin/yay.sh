#!/bin/bash

cd
wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
tar zxvf yay.tar.gz                                                    
cd yay
makepkg --noconfirm -si                                                               
cd ..                                                                     
