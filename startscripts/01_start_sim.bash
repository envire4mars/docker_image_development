#!/bin/bash

# configure
BUNDLE=sherpa_tt_corobx
CND=compositions/simulation.cnd

# trap ctrl-c and call handle_interupt()
trap 'handle_interupt' INT
function handle_interupt() {
    echo -e "\e[32m*** Trapped CTRL-C => shutting down cnd.\e[0m"
    rock-launch halt.cnd
    exit 0
}


source /opt/workspace/env.sh
echo "Using $BUNDLE bundle\n"
rock-bundle-sel $BUNDLE
echo "Restarting omniorb nameserver\n"
bash /opt/workspace/tools/cnd/execution/systemd/omniorb_restart.sh
echo "Starting rock-runtime\n"
rock-runtime &
echo "Launching $CND\n"
rock-launch $CND
