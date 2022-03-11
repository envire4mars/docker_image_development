#!/bin/bash

BUNDLE=sherpa_tt_corobx
if [[ "$1" == "sherpa"* ]]; then
    BUNDLE="sherpa_tt_corobx"
    echo "Using bundle: $BUNDLE"
elif [[ "$1" == "coyote"* ]]; then
    BUNDLE="coyote3_corobx"
    echo "Using bundle: $BUNDLE"
else
   echo "No bundle specified. Using default bundle: $BUNDLE"
fi

source /opt/workspace/env.sh
echo "Restarting omniorb nameserver"
bash /opt/workspace/tools/cnd/orogen/execution/systemd/omniorb_restart.sh
echo "Selecting bundle $BUNDLE"
rock-bundle-sel $BUNDLE
echo "Starting rock_runtime_simple.rb"
rock-runtime
#ruby /opt/workspace/bundles/sherpa_tt_corobx/scripts/rock-runtime-simple.rb
