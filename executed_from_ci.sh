#!/usr/bin/env bash

set -xeuo pipefail

mkdir ~/.ssh
cat authorized_keys >> ~/.ssh/authorized_keys
find ~/.ssh -type f -exec chmod 600 {} \;

declare -p > ~/env.txt

# NOTE: CONTENTS OF THIS FILE AND STDOUT/STDERR LOGS ARE PUBLIC!!!

echo 'freevps' > ~/.sshj_hostname.txt
./servix.sh start ./servix/publish_22_sshj.sh
./servix.sh start ./servix/publish_sshj-port\=22-min\=20-max\=25-xxxx.sh

printf '\n. ~/.profile\n' >> ~/.bash_profile
printf '%s\n' 'set -g default-terminal "xterm-color"' >> ~/.tmux.conf
printf '%s\n' 'set -g mouse on' >> ~/.tmux.conf

sudo apt install -y tigervnc-standalone-server tigervnc-tools x11vnc icewm
mkdir -p ~/.vnc/
echo | vncpasswd -f | tee ~/.vnc/passwd > /dev/null
chmod 600 ~/.vnc/passwd
touch ~/.Xauthority
echo 'unset SESSION_MANAGER' | tee -a ~/.vnc/xstartup > /dev/null
echo 'unset DBUS_SESSION_BUS_ADDRESS' | tee -a ~/.vnc/xstartup > /dev/null
echo 'icewm-session &' | tee -a ~/.vnc/xstartup > /dev/null
chmod +x ~/.vnc/xstartup
vncserver -alwaysshared :1

curl -L https://github.com/novnc/noVNC/archive/refs/tags/v1.6.0.zip -o ~/novnc.zip
unzip ~/novnc.zip
mv ./noVNC* ~/novnc
printf '%s\\n' 'export USER=$(whoami)' | tee -a ~/.bashrc > /dev/null
( bash -c 'echo $$ > ~/tmp_vnc_pid.txt ; ~/novnc/utils/novnc_proxy' &) && while sleep 0.1 ; do curl -sS 127.0.0.1:6080 && break ; done && kill "$(cat ~/tmp_vnc_pid.txt)" && rm ~/tmp_vnc_pid.txt
./servix.sh start ./servix/novnc_localhost.sh

(set +e;(set -e
    ./badvpn-udpgw \
        --logger stdout \
        --loglevel info \
        --listen-addr 0.0.0.0:7200
);echo badvpn-udpgw failed.)&

tail -f /dev/null
