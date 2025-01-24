#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# 🤷
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

# 🤷 🤷 🤷
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example &
  done
else
  polybar --reload example &
fi

