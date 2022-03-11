#!/bin/bash

CND=halt.cnd

if [ "$(ps aux | grep sherpa_tt | wc -l)" -gt "1" ]; then
    DIR=/opt/workspace/bundles/sherpa_tt_corobx/models
elif [ "$(ps aux | grep coyote | wc -l)" -gt "1" ]; then
    DIR=/opt/workspace/bundles/coyote3_corobx/models
else
    echo "Neither sherpa_tt nor coyote3 simulation seems to be running"
    exit 1
fi


source /opt/workspace/env.sh
echo "Launching $CND from $DIR"
cd $DIR
rock-launch $CND
