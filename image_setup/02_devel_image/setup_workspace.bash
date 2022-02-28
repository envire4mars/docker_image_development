#!/bin/bash

# In this file you can add a script that intitializes your workspace

# stop on errors
set -e

BUILDCONF=https://git.hb.dfki.de/corob-x/buildconf.git
BRANCH=master
WORKSPACE_DIR=/opt/workspace

if [ ! $1 = "" ]; then
   echo "overriding git credential helper to $1"
   CREDENTIAL_HELPER_MODE=$1
fi

# for Continuous Deployment builds the mode needs to be overridden to be non-interactive
# if set outside this script, use that value, if unset use cache
CREDENTIAL_HELPER_MODE=${CREDENTIAL_HELPER_MODE:="cache"}

# In this file you can add a script that intitializes your workspace

# ROCK BUILDCONF EXAMPLE
#
if [ ! -f /opt/workspace/env.sh ]; then
    echo -e "\e[32m[INFO] First start: setting up the workspace.\e[0m"

    sudo apt update

    cd $WORKSPACE_DIR

    # set git config
    git config --global user.name "Image Builder"
    git config --global user.email "image@builder.me"
    git config --global credential.helper ${CREDENTIAL_HELPER_MODE}

    # setup ws using autoproj
    wget rock-robotics.org/autoproj_bootstrap
    echo "Getting config_seed.yml from $BUILDCONF directory"
    git clone --branch $BRANCH $BUILDCONF $WORKSPACE_DIR/buildconf && mv $WORKSPACE_DIR/buildconf/config_seed.yml $WORKSPACE_DIR/ && rm -rf $WORKSPACE_DIR/buildconf
    ruby autoproj_bootstrap git $BUILDCONF branch=$BRANCH --seed-config=config_seed.yml --no-interactive
    source env.sh
    aup --no-interactive
    amake

    echo -e "\e[32m[INFO] workspace successfully initialized.\e[0m"
else 
    echo -e "\e[31m[ERROR] workspace already initialized.\e[0m"
    exit 1
fi
