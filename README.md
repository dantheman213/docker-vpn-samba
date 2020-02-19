# docker-vpn-smb

TODO 

## Getting Started

Example is a fresh Ubuntu 18.04 LTS server in the cloud.

### Prereq

```
ufw default deny incoming
ufw allow 22,1194
ufw enable
```

### Setup

```
export LOCAL_VPN_CONFIG_PATH=/etc/openvpn
export LOCAL_VPN_CREDS_PATH=/etc/vpn/credentials
export LOCAL_SHARE_PATH=/samba
export VPN_HOST=vpn.mydomain.com

[ ! -d $LOCAL_SHARE_PATH ] && mkdir -p $LOCAL_SHARE_PATH
chmod 777 $LOCAL_SHARE_PATH

[ ! -d $LOCAL_VPN_CONFIG_PATH ] && mkdir -p $LOCAL_VPN_CONFIG_PATH
docker-compose run --rm openvpn ovpn_genconfig -u udp://$VPN_HOST
docker-compose run --rm openvpn ovpn_initpki
```

1. Enter a passphrase, make sure it's a long secure string, and keep it safe

2. You will then be prompted to enter the server host, enter $VPN_HOST value above

3. /etc/openvpn/pki/private/ca.key enter passphrase same as #1

### Start Containers
```
docker-compose up --build -d
```

### Configure Authentication

```
[ ! -d $LOCAL_VPN_CREDS_PATH ] && mkdir -p $LOCAL_VPN_CREDS_PATH
```

For every user (client) you want to give a certificate to run:

```
export CLIENTNAME="your_client_name"
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
```

1. You will be asked for key to create user, create new key not the same as CA passphrase

```
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $LOCAL_VPN_CREDS_PATH/$CLIENTNAME-vault.ovpn
```

### Connect

Host: `\\172.28.28.28\vault`
Username <type anything>
Password <empty>

## Reference

* http://manpages.ubuntu.com/manpages/xenial/man5/smb.conf.5.html

* https://askubuntu.com/questions/751034/how-do-i-share-samba-via-open-vpn-is-that-possible
