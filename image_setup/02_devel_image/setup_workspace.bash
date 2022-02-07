#!/bin/bash

# In this file you can add a script that intitializes your workspace

# stop on errors
set -e

BUILDCONF=https://git.hb.dfki.de/corob-x/buildconf.git
BRANCH=master

# In this file you can add a script that intitializes your workspace

# ROCK BUILDCONF EXAMPLE
#
if [ ! -f /opt/workspace/env.sh ]; then
    echo -e "\e[32m[INFO] First start: setting up the workspace.\e[0m"

    sudo apt update

    # go to workspace dir
    cd /opt/workspace/

    # set git config
    git config --global user.name "Image Builder"
    git config --global user.email "image@builder.me"
    git config --global credential.helper cache

    # setup ws using autoproj
    wget rock-robotics.org/autoproj_bootstrap
    wget -q https://git.hb.dfki.de/corob-x/buildconf/-/raw/$BRANCH/config_seed.yml
    ruby autoproj_bootstrap git $BUILDCONF branch=$BRANCH --seed-config=config_seed.yml
    source env.sh
    aup
    amake

    echo -e "\e[32m[INFO] workspace successfully initialized.\e[0m"
else 
    echo -e "\e[31m[ERROR] workspace already initialized.\e[0m"
    exit 1
fi
