# Arch Linux Installer Helper

First of all. This is not an automatic way to install Arch Linux, but once it worked for me, than it can work for you also, and that is why I decided to share it.

Second of all ( and still why this is not automatic ), I intended to follow the [The Arch Way](https://wiki.archlinux.org/index.php/Arch_Linux#Principles) philosophy. Meaning that this "helper" might only suit my own needs, but it can give you(and that I just hope) a clue on how to manage for good, the installation of this wonderful Linux Distro.

In other words, don't expect an Ubuntu like installation environment, meaning that you will type a few things on the terminal.

# How does it work?

Well. I guess there is no other way to explain that, but by explaining parts of the code and the way I manage my files in the system.

* The `/skel` directory

This directory is meant to be the location where I save all my configuration files as a backup. This technique avoids me re-configuring all my stuff again, like these following nightmares: `/etc/fstab`, `/boot/grub/grub.cfg`, `/etc/pacman.conf`, and so on (you name it!).

Let me give you a look of my `/skel` directory:

```console
$tree /skel
/skel/
├── boot
│   └── grub
│       └── grub.cfg
├── etc
│   ├── locale.conf
│   ├── locale.gen
│   ├── makepkg.conf
│   ├── NetworkManager
│   │   ├── NetworkManager.conf
│   │   └── system-connections
│   │       └── Itamar 
│   ├── pacman.conf
│   ├── pacman.d
│   │   └── mirrorlist
│   ├── samba
│   │   └── smb.conf
│   ├── ssh
│   │   ├── ssh_config
│   │   └── sshd_config
│   ├── sudoers
│   ├── systemd
│   │   ├── coredump.conf
│   │   ├── journald.conf
│   │   ├── journal-remote.conf
│   │   ├── journal-upload.conf
│   │   ├── logind.conf
│   │   ├── resolved.conf
│   │   ├── system.conf
│   │   ├── timesyncd.conf
│   │   └── user.conf
│   ├── X11
│   │   └── xorg.conf.d
│   │       ├── 10-evdev.conf
│   │       ├── 10-radeon.conf
│   │       └── 50-synaptics.conf
│   └── yaourtrc
├── home
│   └── i
│       ├── Downloads -> /i/data/Downloads
│       ├── Library -> /i/data/Library
│       ├── Musics -> /i/data/Musics
│       ├── UFPA -> /i/data/UFPA
│       └── Videos -> /i/data/Videos
├── pkg
│   ├── aur.txt
│   ├── base.txt
│   ├── gem.txt
│   ├── npm.txt
│   ├── pacman.txt
│   └── pip.txt
└── root
    ├── Downloads -> /i/data/Downloads
    ├── Library -> /i/data/Library
    ├── Musics -> /i/data/Musics
    ├── UFPA -> /i/data/UFPA
    └── Videos -> /i/data/Videos

25 directories, 31 files
```

so the point is ... I put my stuff there and (for the sake of my lazyness) I let `rsync` do the magic for me after the installation process is done. Well, there is no need to keep doing `cp` this and that a thousand times over.

So I guess this technique is basicaly optional. You use, or adapt, as you wish. But if you don't use it, just care to comment out the right lines where `/skel` appears (`install.sh`, `main.py's output variable`, `config.sh`, `yaourt.sh` and `after.sh`).

* The `main.py` and `packages.yml`

Their only purpose is to generate `/skel/pkg` text files in an organized way. I'm very fond of [YAML's](https://en.wikipedia.org/wiki/YAML) syntax to categorize things I'm gonna use in scripts, so that's why I used it.

If you don't want to use them, just write the names of the packages you want to use, just like it is in the `pkg` folder, and care for changing the entries of `/skel`, as mentioned above, accordingly.

But if you care to use them, then install `python-pip` and pip's package `pyyaml`. On Arch Linux:

```console
$sudo pacman -S python-pip
$sudo pip install pyyaml
```

the syntax for this YAML file is the following:

```c
#include <stdio.h>
---

base : 'base base-devel ...' 

categories: 
    
    category01:
        pacman:
            pkg1
            pkg2
            pkg3
            ...
            pkgN
        aur:
            pkg1
            pkg2
            pkg3
            ...
            pkgN

        # and so on

    category02:
        pacman:
            pkg1
            pkg2
            pkg3
            ...
            pkgN
        npm:
            pkg1
            pkg2
            pkg3
            ...
            pkgN

        # and so on
```

the name of each category is unimportant, but the [scalars](http://yaml.org/spec/1.2/spec.html#id2760844) `base`, `categories`, `pacman`, `aur`, `gem`, `pip` and `npm` must have these names (case sensitive).

Though you can omit one or more packers (pacman, npm, etc) you cannot create a category with nothing. If so, comment it out from the list.


* `install.sh`, `config.sh`, `yaourt.sh` and `after.sh`

For short. `install.sh` and `config.sh` are required and `yaourt.sh` and `after.sh` aren't. Why?

`install.sh` is where the system will be installed so becareful with this part, 'cause things can get a bit hairy if you write things at the wrong location. For the sake of my system, as you can see inside it, I'm using `pacstrap` in a non-mounting point (regular folder), as follows:

```console
INSTALL_DIR="/i/project/ArchLinux/arch" # to be changed accordingly
_SKEL_DIR="/skel"                       # same shit

pacstrap -c -d $INSTALL_DIR $(cat ${_SKEL_DIR}/pkg/base.txt)
```

after that, it does the following:

1. rsyncs my pacman's cache and the skeleton folder to the new installation folder.
2. it copies the 3 other scripts to be run into chroot environment.
3. enables yaourt to be run in a non-tty environment, by copying an alternative `/etc/sudoers` aiming to give the normal user real super powers so yaourt doesn't even bother him asking for his password. As a matter of fact, this sort of "solution" is known as "gambiarra" here where I live, which is a non-standard (quick and careless) solution. If you have a way out, please (PLEASE) don't be a dick and share with me. 

`config.sh` is meant to be run after you shoot the `arch-chroot` command, such as the following:


```console
#arch-chroot <directory of your new system> /bin/bash
chroot-prompt[/]#sh config.sh
```

after that your [prompt](https://en.wikipedia.org/wiki/Command-line_interface#Command_prompt) might change to something else, which means you have entered your new system in a chroot way. But before you fuck your system up, take a look at the content of the file, so you can change the variables accordingly to your needs.

`yaourt.sh` is meant to be run after `config.sh`, and still into chroot environment, and logged into your new normal (and very powerful) user. So you do:

```console
chroot-prompt[/]#su <username>
chroot-prompt[/]$sh /yaourt.sh
```

so the script basicaly install `package-query` and `yaourt` and your AUR packages stored into `/skel/pkg/aur.txt`. Be aware that it does all the job without asking you for confirmation, once the `--noconfirm` option was provided. After it is done (it will take long!), you suppose to get out from the normal user back to the root user by pressing `Ctrl+d` or typing `exit`.

`after.sh` is meant to be run after `yaourt.sh` is done. It basicaly does some cleaning and, not less important, it does the rsyncing of all my configuration files stored into `/skel` folder, including the real `/etc/sudoers` that will revoke the super powers back from the normal user. For that reason, it is meant to be run as `root` user.

# What do I do after all that?

I usually mount the partition where I intend to install the system into. This partition must be formated accordingly to your demands. And once it is mounted, I just run:

```console
#rsync -aAXvz <installation folder> <mounted folder>
```

one should notice that the `skel` folder goes along with the whole thing. By doing that I can reuse it again in another installation, which kinda "completes" or "continues" the cycle.

At this point, it just has the system's directory structure installed. You still have to set up the `grub+BIOS` or `grub+EFI` boring part, not to mention the partitioning and formating parts that is done before.

# License

This piece of software is under the `I don't care` license. So do whatever you want, I care not.

# If you liked this project

then you might like my other projects at [iasj](https://github.com/iasj).

But if didn't, then you can checkout this awesome project that inspired me: [AUI](https://github.com/helmuthdu/aui). It has a huge list of packages and is very interactive. It feels like Ubuntu's installation without GUI.

That's all Archers, good bye!

