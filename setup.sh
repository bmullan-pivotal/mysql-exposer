#!/bin/bash
export dbhostname=`echo $VCAP_SERVICES | jq -r .'"p.mysql"'[0].credentials.hostname`
export     dbport=`echo $VCAP_SERVICES | jq -r .'"p.mysql"'[0].credentials.port`

cp /home/vcap/app/bin/haproxy/haproxy.config /home/vcap/app/bin/haproxy/haproxy.config.old
sed -i "s/.*DBCONNECTIONDETAILS.*/server server1 $dbhostname:$dbport  maxconn 32/" /home/vcap/app/bin/haproxy/haproxy.config
