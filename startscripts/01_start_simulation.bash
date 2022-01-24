#!/bin/bash

BUNDLE=sherpa_tt_corobx
CND=simulation.cnd

if [[ "$1" == "sherpa"* ]]; then
    BUNDLE="sherpa_tt_corobx"
elif [[ "$1" == "coyote"* ]]; then
    BUNDLE="coyote3_corobx"
else
   echo "No bundle specified. Using default bundle: $BUNDLE"
fi

source /opt/workspace/env.sh
echo "Using $BUNDLE bundle"
rock-bundle-sel $BUNDLE
echo "Launching $CND"
rock-launch -b $CND
