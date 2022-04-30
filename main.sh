#!/bin/bash


#change the following to "false" to disable updating of server jars
syncjars="true"


#DANGER!! setting the following to "true" will redownload the bukkit server! only change if you know what you are doing!
emergupd="false"



#~#       this code was smashed together by ayunami2000       #~#

eagurl="https://raw.githubusercontent.com/LAX1DUDE/eaglercraft/main/stable-download/stable-download_repl.zip"

echo ensuring old server process is truly closed...
pkill java

echo checking if file still works...

status_code=$(curl -L --write-out %{http_code} --silent --output /dev/null "$eagurl")

if [[ "$status_code" -ne 200 ]] ; then
  syncjars="false"
  echo "


site is down! not updating...


"
else
  echo site is still up! downloading...
  curl -L -o stable-download.zip "$eagurl"
  echo extracting zip...
  mkdir /tmp/new
  unzip stable-download.zip -d /tmp/new
  echo deleting original zip file...
  rm -rf stable-download.zip
  mkdir java
  mkdir java/bungee_command
  mkdir java/bukkit_command
  if [ "$syncjars" = "true" ]; then
    echo updating bungeecord server...
    rm -f java/bungee_command/bungee-dist.jar
    cp /tmp/new/java/bungee_command/bungee-dist.jar ./java/bungee_command/
    echo updating bukkit server...
    if [ "$emergupd" = "true" ]; then
      rm -rf java/bukkit_command/*
      cp -r /tmp/new/java/bukkit_command/. ./java/bukkit_command/
    else
      rm -f java/bukkit_command/craftbukkit-1.5.2-R1.0.jar
      cp /tmp/new/java/bukkit_command/craftbukkit-1.5.2-R1.0.jar ./java/bukkit_command/
    fi
  fi
  echo removing update data...
  rm -rf /tmp/new
fi

echo starting bungeecord...
cd java/bungee_command
java -Xmx32M -Xms32M -jar bungee-dist.jar > /dev/null 2>&1 &
cd ../..

echo starting bukkit...
cd java/bukkit_command
java -Xmx512M -Xms512M -jar craftbukkit-1.5.2-R1.0.jar
cd ../..

echo done!