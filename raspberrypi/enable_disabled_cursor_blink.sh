#!/bin/sh

if systemctl list-units --full -all | grep -q "stop-cursor-blink.service"; then
  systemctl disable stop-cursor-blink.service
fi
