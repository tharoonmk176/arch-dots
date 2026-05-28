#!/usr/bin/env bash
# Gaming mode indicator (JSON)

if [ -f /tmp/hypr-gaming-mode ]; then
    printf '{"text":"󰓓","tooltip":"Gaming mode ON — click to disable","class":"active"}\n'
else
    printf '{"text":"","tooltip":"","class":"hidden"}\n'
fi
