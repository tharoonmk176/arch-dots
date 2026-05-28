#!/usr/bin/env bash
free -m | awk '/Mem:/ { printf("%d", $3/$2*100) }'
