#!/bin/bash

BUNDLE=sherpa_tt_corobx
#BUNDLE=coyote3_launch
if [ "$1" ]; then
   BUNDLE="$1"
fi
echo "Using bundle: $BUNDLE"

source /opt/workspace/env.sh
echo "Restarting omniorb nameserver"
bash /opt/workspace/tools/cnd/orogen/execution/systemd/omniorb_restart.sh
echo "Selecting bundle $BUNDLE"
rock-bundle-sel $BUNDLE
echo "Starting rock_runtime_simple.rb"
ruby /opt/workspace/bundles/sherpa_tt_corobx/scripts/rock-runtime-simple.rb
