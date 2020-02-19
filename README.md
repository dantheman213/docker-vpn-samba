# docker-vpn-smb

TODO 

## Getting Started

### Setup

```
export LOCAL_VPN_CONFIG_PATH=/etc/openvpn
export LOCAL_VPN_CREDS_PATH=/etc/vpn/credentials
export LOCAL_SHARE_PATH=/samba

#export OVPN_DATA=ovpn-data-vpn-vault
export VPN_HOST=vpn.mydomain.com

[ ! -d $LOCAL_VPN_CONFIG_PATH ] && mkdir -p $LOCAL_VPN_CONFIG_PATH
docker-compose -f docker-compose.vpn.yml run --rm openvpn ovpn_genconfig -u udp://$VPN_HOST
docker-compose -f docker-compose.vpn.yml run --rm openvpn ovpn_initpki
```

1. Enter a passphrase, make sure it's a long secure string, and keep it safe

2. You will then be prompted to enter the server host, enter $VPN_HOST value above

3. /etc/openvpn/pki/private/ca.key enter passphrase same as #1

```
#chown -R $(whoami): $OVPN_DATA
```

### Start Containers
```
docker-compose \
-f docker-compose.yml \
-f docker-compose.vpn.yml \
up \
--build -d
```

### Configure Authentication

```
[ ! -d $LOCAL_VPN_CREDS_PATH ] && mkdir -p $LOCAL_VPN_CREDS_PATH
```

For every user (client) you want to give a certificate to run:

```
export CLIENTNAME="your_client_name"
docker-compose -f docker-compose.vpn.yml run --rm openvpn easyrsa build-client-full $CLIENTNAME
```

1. You will be asked for key to create user, create new key not the same as CA passphrase

```
docker-compose -f docker-compose.vpn.yml run --rm openvpn ovpn_getclient $CLIENTNAME > $LOCAL_VPN_CONFIG_PATH/$CLIENTNAME.ovpn
```

### Connect

Host: `[smb:]\\<ip address or host>\vault`

## Reference

* http://manpages.ubuntu.com/manpages/xenial/man5/smb.conf.5.html

* https://askubuntu.com/questions/751034/how-do-i-share-samba-via-open-vpn-is-that-possible
