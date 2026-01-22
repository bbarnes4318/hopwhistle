#!/bin/bash
docker exec docker-freeswitch-1 sed -i 's/value=""/value="domains"/' /etc/freeswitch/autoload_configs/event_socket.conf.xml
docker exec docker-freeswitch-1 fs_cli -x 'reload mod_event_socket'
echo "ACL Fix Applied and Module Reloaded"
