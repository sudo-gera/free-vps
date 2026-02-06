#!/usr/bin/env bash

set -xeuo pipefail

( set -x ; export USERNAME='gera07a02-vpnjantit.com'     && export HOSTNAME='ee2.vpnjantit.com'     && export PASSWORD='1234567890'     && while sleep 1 ; do ( echo 'ssh -oPasswordAuthentication=yes -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -vvv -l "${USERNAME}" "${HOSTNAME}" -N -R 127.0.0.1:0:127.0.0.1:22 ; exit' ; for q in $(seq 1 160) ; do sleep 0.1 ; if grep password: /tmp/vpnjantit-"$(id -u)".txt >/dev/null ; then printf '%s\n' "$PASSWORD" ; exit ; fi ; done ; for q in $(seq 1 160) ; do sleep 0.1 ; printf $'\x03\x04' ; done ; ) | if script --version ; then script -f /tmp/vpnjantit-"$(id -u)".txt ; else script -F /tmp/vpnjantit-"$(id -u)".txt bash ; fi ; done )

sleep 18000
