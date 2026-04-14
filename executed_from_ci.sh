#!/usr/bin/env bash

set -xeuo pipefail

mkdir ~/.ssh
cat authorized_keys >> ~/.ssh/authorized_keys
find ~/.ssh -type f -exec chmod 600 {} \;

declare -p > ~/env.txt

sudo apt install -y tmate

echo 'freevps' > ~/.sshj_hostname.txt

./servix.sh start ./tmate.sh

./servix.sh start ./publish_22_sshj.sh

