#!/bin/bash
set -e

export DISPLAY=:0
rm -f /tmp/.X0-lock

# ✅ 设置 VNC 密码（从环境变量传入）
VNC_PASSWORD=${VNC_PASSWORD:-wechat123}
mkdir -p /root/.vnc
rm -f /root/.vnc/passwd
echo "$VNC_PASSWORD" | x11vnc -storepasswd - /root/.vnc/passwd
chmod 600 /root/.vnc/passwd


echo "当前密码为: $VNC_PASSWORD"
env | grep VNC_PASSWORD >> /var/log/vnc_debug.log

# ✅ 设置显示分辨率
RESOLUTION="${DISPLAY_RESOLUTION:-1280x720x24}"

# ✅ 启动虚拟屏幕
Xvfb :0 -screen 0 $RESOLUTION &
sleep 2

# ✅ 启动输入法守护
fcitx -d &

# ✅ 启动窗口管理器
openbox &

# ✅ 启动 VNC + noVNC 网页服务
x11vnc -display :0 -rfbauth /root/.vnc/passwd -forever -shared &
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &

# ✅ 启动微信
cd /opt/wechat
./WeChat.AppImage --appimage-extract || true
cd squashfs-root

# ✅ 设置中文输入法环境变量
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

./AppRun &

wait
