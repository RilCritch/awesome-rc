#!/usr/bin/env bash

function run {
  if ! pgrep -x $(basename $1 | head -c 15) 1>/dev/null;
  then
    $@&
  fi
}

# System Management
run xfce4-power-manager &
run picom --config /home/rc/Repos/awesome-ril/scripts/picom.conf &
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

