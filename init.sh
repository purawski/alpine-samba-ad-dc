#!/bin/sh
if [ -e /etc/samba/smb.conf ]; then
    samba -i 
else
    sleep infinity
fi