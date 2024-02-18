#!/usr/bin/env bash

function run {
  if ! pgrep -x $(basename $1 | head -c 15) 1>/dev/null;
  then
    "$@"&
  fi
}

# System Management
run xfce4-power-manager &
picom --config /home/rc/Repos/awesome-rc/scripts/picom.conf &
run /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
run /home/rc/.local/share/cargo/bin/clipcatd
