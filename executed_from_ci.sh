#!/usr/bin/env bash

set -xeuo pipefail

mkdir ~/.ssh
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKx1v6YK2wvU9jy5iAINeZE3PYjLUaLh0SGdiajFgHP gera@MacBook-Air-gera-4.local' >> ~/.ssh/authorized_keys
find ~/.ssh -type f -exec chmod 600 {} \;

( set -x ; export USERNAME='gera07a02-vpnjantit.com'     && export HOSTNAME='ee2.vpnjantit.com'     && export PASSWORD='1234567890'     && while sleep 1 ; do ( echo 'ssh -oPasswordAuthentication=yes -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -vvv -l "${USERNAME}" "${HOSTNAME}" -N -R 127.0.0.1:0:127.0.0.1:22 ; exit' ; for q in $(seq 1 160) ; do sleep 0.1 ; if grep password: /tmp/vpnjantit-"$(id -u)".txt >/dev/null ; then printf '%s\n' "$PASSWORD" ; exit ; fi ; done ; for q in $(seq 1 160) ; do sleep 0.1 ; printf $'\x03\x04' ; done ; ) | if script --version ; then script -f /tmp/vpnjantit-"$(id -u)".txt ; else script -F /tmp/vpnjantit-"$(id -u)".txt bash ; fi ; done )

sleep 18000
