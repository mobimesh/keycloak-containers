#!/bin/bash
FILE1=/opt/radius/localcert/389ds_ca.cert
FILE2=/opt/radius/cert/389ds_ca.cert
if [ ! -f "$FILE1" ]; then
  cp /opt/radius/cert/389ds_ca.cert /opt/radius/localcert/389ds_ca.cert
fi

RES1=$(md5sum $FILE1)
RES2=$(md5sum $FILE2)

if [[ "$RES1" == "$RES2" ]]; then
    keytool -importcert -noprompt -alias 389ds_ca -keystore /etc/alternatives/jre/lib/security/cacerts -storepass changeit -file /opt/radius/localcert/389ds_ca.cert
else
    cp /opt/radius/cert/389ds_ca.cert /opt/radius/localcert/389ds_ca.cert
    keytool -importcert -noprompt -alias 389ds_ca -keystore /etc/alternatives/jre/lib/security/cacerts -storepass changeit -file /opt/radius/localcert/389ds_ca.cert
fi

su - dockeruser
/opt/radius/scripts/radius-keycloak.sh $@
/opt/jboss/tools/docker-entrypoint.sh $@
