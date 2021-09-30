#!/bin/bash

BUNDLE=sherpa_tt_corobx

source /opt/workspace/env.sh
echo "Restarting omniorb nameserver"
bash /opt/workspace/tools/cnd/orogen/execution/systemd/omniorb_restart.sh
echo "Selecting bundle $BUNDLE"
rock-bundle-sel $BUNDLE
echo "Starting rock_runtime_simple.rb"
ruby /opt/workspace/bundles/sherpa_tt_corobx/scripts/rock-runtime-simple.rb
