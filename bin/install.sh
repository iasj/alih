#!/bin/bash

output=./sys
cache=var/cache/pacman/pkg

sudo mkdir -p $output/$cache 
sudo pacman -Syu
sudo rsync -aAXvzu /$cache/* $output/$cache
sudo pacstrap -d $output $(cat pkg/base.txt)
sudo pacstrap -d $output $(cat pkg/pacman.txt)
