#!/bin/sh

/etc/init.d/rsyslog start
tail -f /var/log/syslog &

su cyrus -c /usr/cyrus/bin/mkimap

exec /usr/cyrus/bin/master