#!/usr/bin/env bash
# Short wifi/eth label (text only — avoids network module icon quirks)

if nmcli -t -f STATE dev 2>/dev/null | grep -q '^connected'; then
    if nmcli -t -f TYPE,STATE dev 2>/dev/null | grep -q '^wifi:connected'; then
        printf '{"text":"wifi","tooltip":"Wi-Fi connected","class":"wifi"}\n'
    else
        printf '{"text":"eth","tooltip":"Ethernet connected","class":"eth"}\n'
    fi
else
    printf '{"text":"off","tooltip":"Offline","class":"off"}\n'
fi
