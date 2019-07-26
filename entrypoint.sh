#!/bin/sh

/etc/init.d/rsyslog start
sleep 1
/etc/init.d/bind9 start
tail -f -n +1 /var/log/syslog
