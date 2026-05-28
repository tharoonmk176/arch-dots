#!/usr/bin/env bash
# Caps / Num lock indicators (reference-style)

parts=()

if command -v xset >/dev/null 2>&1; then
    map=$(xset -q 2>/dev/null | awk -F: '/Caps Lock|Num Lock/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $1, $2}')
    caps=$(echo "$map" | awk '$1=="Caps Lock"{print $2}')
    num=$(echo "$map" | awk '$1=="Num Lock"{print $2}')
    [ "${caps:-}" = "on" ] && parts+=("Caps")
    [ "${num:-}" = "on" ] && parts+=("Num")
fi

if [ "${#parts[@]}" -eq 0 ]; then
    exit 0
fi

if [ "${#parts[@]}" -gt 0 ]; then
    text=$(IFS='  '; echo "${parts[*]}")
    printf '{"text":"%s","tooltip":"%s","class":"locks"}\n' "$text" "$text"
fi
