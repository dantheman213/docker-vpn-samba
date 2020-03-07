#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Provide domain where VPN will be hosted at. (e.g. subdomain.mydomain.com or mydomain.com)"
    exit 1
fi

start=`date +%s`

echo "Saving env vars..."
mkdir -p /etc/openvpn/credentials
echo "export DVS_LOCAL_VPN_CONFIG_PATH=/etc/openvpn" >> /etc/environment
echo "export DVS_LOCAL_VPN_CREDS_PATH=/etc/vpn/credentials" >> /etc/environment
echo "export DVS_LOCAL_SHARE_PATH=/samba" >> /etc/environment
echo "export DVS_VPN_HOST=$1" >> /etc/environment
source /etc/environment

[ ! -d $DVS_LOCAL_SHARE_PATH ] && mkdir -p $DVS_LOCAL_SHARE_PATH
chmod -R 777 $DVS_LOCAL_SHARE_PATH

[ ! -d $DVS_LOCAL_VPN_CONFIG_PATH ] && mkdir -p $DVS_LOCAL_VPN_CONFIG_PATH

[ ! -d $DVS_LOCAL_VPN_CREDS_PATH ] && mkdir -p $DVS_LOCAL_VPN_CREDS_PATH

echo "Upgrading system and installing dependencies..."
apt-get update
apt-get upgrade -y
apt-get install -y docker docker-compose

echo "Configuring ufw firewall..."
ufw default deny incoming
ufw allow 22
ufw allow 1194/udp
ufw --force enable # non-interactive

echo "Grab DockerHub VPN image..."
echo "Generate OVPN config..."
docker-compose run --rm openvpn ovpn_genconfig -u udp://$DVS_VPN_HOST
docker-compose run --rm openvpn ovpn_initpki

echo "Generate OVPN keys and certificates..."
docker-compose run --rm openvpn ovpn_initpki

end=`date +%s`
runtime=$((end-start))
runtime_pretty=$(date -d@$runtime -u +%H:%M:%S)

printf "\n\nTotal time is $runtime_pretty.\nCOMPLETE!\n"