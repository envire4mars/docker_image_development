#!/bin/bash

BUNDLE=sherpa_tt_corobx
CND=simulation.cnd


# trap ctrl-c and call handle_interupt()
trap 'handle_interupt' INT
function handle_interupt() {
    echo -e "\e[32m*** Trapped CTRL-C => shutting down cnd.\e[0m"
    #rock-launch /opt/workspace/bundles/sherpa_tt_corobx/models/halt.cnd
    #killall -SIGINT rock-runtime
    exit 0
}

source /opt/workspace/env.sh
echo "Restarting omniorb nameserver"
bash /opt/workspace/tools/cnd/orogen/execution/systemd/omniorb_restart.sh
echo "Selecting bundle $BUNDLE"
rock-bundle-sel $BUNDLE
echo "Starting rock_runtime_simple.rb"
#ruby /opt/workspace/bundles/sherpa_tt_corobx/scripts/rock-runtime-simple.rb
rock-runtime &

sleep 5

echo "Launching $CND"
rock-launch -b $CND

echo "Stop application by pressing 'q'"
while true
do
    read -n 1 k <&1
    if [[ $k = q ]]; then
        rock-launch /opt/workspace/bundles/sherpa_tt_corobx/models/halt.cnd
        killall -SIGINT rock-runtime
        exit 0
    else
        echo "Stop application by pressing 'q'"
    fi
done
