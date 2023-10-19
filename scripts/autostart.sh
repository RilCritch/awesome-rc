#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# System Management
run xfce4-power-manager
run picom --config /home/rc/Repos/awesome-ril/scripts/picom.conf

