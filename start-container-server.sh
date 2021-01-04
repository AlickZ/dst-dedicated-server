#!/bin/bash

# 每次开始前检查游戏更新。如果游戏客户端更新了，而你的服务器已经过时了，你就不会被更新
# 可以在服务器列表中看到它。如果发生这种情况，只需重新启动容器，您应该得到最新版本
/home/dst/steamcmd.sh +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir /home/dst/server_dst +app_update 343050 validate +quit

# 复制mod配置文件
ds_mods_setup="$HOME/.klei/DoNotStarveTogether/DSTWhalesCluster/mods/dedicated_server_mods_setup.lua"
if [ -f "$ds_mods_setup" ]
then
  cp $ds_mods_setup "$HOME/server_dst/mods/"
fi

# 复制 modoverrides.lua
modoverrides="$HOME/.klei/DoNotStarveTogether/DSTWhalesCluster/mods/modoverrides.lua"
if [ -f "$modoverrides" ]
then
  cp $modoverrides "$HOME/.klei/DoNotStarveTogether/DSTWhalesCluster/Master/"
  cp $modoverrides "$HOME/.klei/DoNotStarveTogether/DSTWhalesCluster/Caves/"
fi

cd $HOME/server_dst/bin
./dontstarve_dedicated_server_nullrenderer -cluster DSTWhalesCluster -shard "$SHARD_NAME"
