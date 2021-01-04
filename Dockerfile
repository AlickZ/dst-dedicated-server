FROM debian:latest

# 创建运行DST服务器的特定用户
RUN useradd -ms /bin/bash/ dst
WORKDIR /home/dst

# 安装所需的软件包
RUN set -x && \
    dpkg --add-architecture i386 && \
    apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y wget ca-certificates lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386 && \
    # 下载Steam命令 (https://developer.valvesoftware.com/wiki/SteamCMD#Downloading_SteamCMD)
    wget -q -O - "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
    chown -R dst:dst ./ && \
    # 清理
    apt-get autoremove --purge -y wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER dst
RUN mkdir -p .klei/DoNotStarveTogether server_dst/mods

# 安装饥荒
RUN ./steamcmd.sh \
    +@ShutdownOnFailedCommand 1 \
    +@NoPromptForPassword 1 \
    +login anonymous \
    +force_install_dir /home/dst/server_dst \
    +app_update 343050 validate \
    +quit

VOLUME ["/home/dst/.klei/DoNotStarveTogether", "/home/dst/server_dst/mods"]

COPY ["start-container-server.sh", "/home/dst/"]
ENTRYPOINT ["/home/dst/start-container-server.sh"]
