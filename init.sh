#!/bin/sh
if [ -e /etc/samba/smb.conf ]; then
    /usr/sbin/samba --debug-stderr -d2
    /usr/sbin/radiusd
    sleep infinity
else
    sleep infinity
fi
