#!/usr/bin/env bash
# Performance / gaming mode label (reference "Max" style)

if [ -f /tmp/hypr-gaming-mode ]; then
    printf '{"text":"Max","tooltip":"Performance mode — click for balanced","class":"on"}\n'
else
    printf '{"text":"Bal","tooltip":"Balanced — click for performance","class":"off"}\n'
fi
