#!/bin/bash

BUNDLE=sherpa_tt_corobx
CND=simulation.cnd
LOGDIR=/opt/workspace

# trap ctrl-c and call handle_interupt()
trap 'handle_interupt' INT
function handle_interupt() {
    echo -e "\e[32m*** Trapped CTRL-C => shutting down cnd.\e[0m"
    stop_cnd
    exit 0
}

function stop_cnd(){
    rock-launch /opt/workspace/bundles/$BUNDLE/models/halt.cnd
    killall -SIGINT rock-runtime || true
}


if [[ "$1" == "sherpa"* ]]; then
    BUNDLE="sherpa_tt_corobx"
elif [[ "$1" == "coyote"* ]]; then
    BUNDLE="coyote3_corobx"
else
   echo "No bundle specified. Using default bundle: $BUNDLE"
fi

source /opt/workspace/env.sh
echo "Restarting omniorb nameserver"
bash /opt/workspace/tools/cnd/orogen/execution/systemd/omniorb_restart.sh
echo "Selecting bundle $BUNDLE"
rock-bundle-sel $BUNDLE
echo "Starting rock_runtime"
rock-runtime > $LOGDIR/rock-runtime.log 2>&1 &
{ tail -n +1 -f $LOGDIR/rock-runtime.log & } | sed -n '/Press\ <CTRL+C>\ to\ exit.../q'

echo "Launching $CND"
rock-launch -b $CND

echo "Stop application by pressing 'q'"
while true
do
    read -n 1 k <&1
    if [[ $k = q ]]; then
        stop_cnd
        exit 0
    else
        echo "Stop application by pressing 'q'"
    fi
done
