#!/bin/bash

BUNDLE=""
CND=halt.cnd

if [ "$(ps aux | grep sherpa_tt | wc -l)" -gt "1" ]; then
    BUNDLE=sherpa_tt_corobx
    DIR=/opt/workspace/bundles/sherpa_tt_corobx/models
elif [ "$(ps aux | grep coyote | wc -l)" -gt "1" ]; then
    BUNDLE=coyote3_launch
    DIR=/opt/workspace/bundles/coyote3_corobx/models
else
    echo "Neither sherpa_tt nor coyote3 simulation seems to be running"
    exit 1
fi


source /opt/workspace/env.sh
echo "Using $BUNDLE bundle to launch $CND from $DIR"
cd $DIR
#rock-bundle-sel $BUNDLE
rock-launch $CND
