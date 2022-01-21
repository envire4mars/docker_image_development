#!/bin/bash

# configure
BUNDLE=coyote3_corobx
CND=simulation.cnd

# trap ctrl-c and call handle_interupt()
trap 'handle_interupt' INT
function handle_interupt() {
    echo -e "\e[32m*** Trapped CTRL-C => shutting down cnd.\e[0m"
    rock-launch halt.cnd
    exit 0
}


source /opt/workspace/env.sh
echo "Using $BUNDLE bundle"
rock-bundle-sel $BUNDLE
echo "Launching $CND"
rock-launch -b $CND
