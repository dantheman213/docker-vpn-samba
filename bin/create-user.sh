#!/usr/bin/env bash

source /etc/environment

if [ -z "$1" ]; then
    echo "Please specify a username!"
    exit 1
fi

# Generate creds
CLIENTNAME=$1
OUTPUT_FILE=$OVPN_CONFIG_CREDS_PATH/$CLIENTNAME-vault.ovpn

docker-compose -f ../docker/docker-compose.yml run --rm openvpn easyrsa build-client-full $CLIENTNAME
docker-compose -f ../docker/docker-compose.yml run --rm openvpn ovpn_getclient $CLIENTNAME > $OUTPUT_FILE

sed -i '/redirect-gateway def1/d' $OUTPUT_FILE
echo "route-nopull" >> $OUTPUT_FILE
echo "route 172.28.28.28 255.255.255.255" >> $OUTPUT_FILE

echo "Writing to file $OUTPUT_FILE"
