#!/bin/bash
rm -rf /run/httpd/* /tmp/httpd*
rm -rf /var/log/http/

exec /usr/sbin/apachectl -DFOREGROUND
