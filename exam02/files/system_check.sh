#!/bin/bash

for service in sshd chronyd firewalld
do
    systemctl is-active $service >/dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "$service: running"
    else
        echo "$service: stopped"
    fi
done