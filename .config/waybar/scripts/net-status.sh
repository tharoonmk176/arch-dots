#!/usr/bin/env bash
# Network line like reference: wlo1 via 192.168.1.5/24

set -euo pipefail

IF=$(nmcli -t -f DEVICE,STATE,TYPE dev status 2>/dev/null | awk -F: '$2=="connected" && $3!="loopback"{print $1; exit}')
IF=${IF:-offline}

if [ "$IF" = "offline" ]; then
    printf '{"text":"offline","tooltip":"No connection","class":"offline"}\n'
    exit 0
fi

IP=$(ip -4 -o addr show dev "$IF" 2>/dev/null | awk '{print $4}' | head -1)
IP=${IP:-no ip}

printf '{"text":"wifi","tooltip":"%s · %s","class":"net"}\n' "$IF" "$IP"
