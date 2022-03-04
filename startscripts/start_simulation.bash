#!/bin/bash

##################################################################################### CONSTANTS ###
BUNDLE=sherpa_tt_corobx
CND=simulation.cnd # moon = default
LOGDIR=/opt/workspace


##################################################################################### FUNCTIONS ###
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

function eval_args(){
    if [[ "$1" == "sherpa"* ]]; then
        BUNDLE="sherpa_tt_corobx"
    elif [[ "$1" == "coyote"* ]]; then
        BUNDLE="coyote3_corobx"
    elif [[ "$1" == "aruco" ]]; then
        CND="simulation_aruco.cnd"
    elif [[ "$1" == "moon" ]]; then
        CND="simulation.cnd"
    elif [[ "$1" == "maguez" ]]; then
        CND="simulation_maguez.cnd"
    else
       echo "Unknown argument passed: $1"
       exit
    fi
}

########################################################################################## MAIN ###
while ! [ -z "$1" ]; do
    eval_args $1
    shift
done

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
