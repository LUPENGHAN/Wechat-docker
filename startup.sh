#!/bin/bash
set -e

export DISPLAY=:0
rm -f /tmp/.X0-lock

RESOLUTION="${DISPLAY_RESOLUTION:-1280x720x24}"

Xvfb :0 -screen 0 $RESOLUTION &sleep 2

openbox &

x11vnc -display :0 -nopw -forever -shared &
websockify --web=/usr/share/novnc/ 6080 localhost:5900 || true &

cd /opt/wechat
./WeChat.AppImage --appimage-extract || true
cd squashfs-root
./AppRun &

wait
