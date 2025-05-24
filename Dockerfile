FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 安装依赖
RUN apt update && apt install -y \
    wget curl sudo x11vnc xvfb openbox fcitx fcitx-pinyin fcitx-frontend-gtk3 \
    novnc websockify libfuse2 libgbm1 \
    fonts-wqy-zenhei language-pack-zh-hans \
    libgtk-3-0 libnss3 libxss1 libasound2 libx11-xcb1 \
    libxcomposite1 libxdamage1 libxrandr2 libxinerama1 \
    libxfixes3 libxrender1 libxi6 libxtst6 libdbus-1-3 \
    libxkbcommon-x11-0 libgl1 libgconf-2-4 \
    libxcb-icccm4 libxcb-image0 libxcb-xinerama0 \
    libxcb-render-util0 libxcb-keysyms1 libatomic1 && \
    locale-gen zh_CN.UTF-8 && \
    apt clean && rm -rf /var/lib/apt/lists/*

ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8

# 下载 WeChat AppImage
RUN mkdir -p /opt/wechat && \
    wget -O /opt/wechat/WeChat.AppImage https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage && \
    chmod +x /opt/wechat/WeChat.AppImage

COPY startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

EXPOSE 6080
CMD ["bash", "/opt/startup.sh"]
