# docker-vpn-smb

TODO 

## Getting Started

### Setup

```
export LOCAL_VPN_CONFIG_PATH=/etc/openvpn
export LOCAL_SHARE_PATH=/samba

export OVPN_DATA=ovpn-data-vpn-vault
export VPN_HOST=vpn.mydomain.com

[ ! -d $LOCAL_VPN_CONFIG_PATH ] && mkdir -p $LOCAL_VPN_CONFIG_PATH
docker-compose run --rm openvpn ovpn_genconfig -u udp://$VPN_HOST
docker-compose run --rm openvpn ovpn_initpki
chown -R $(whoami): ./$OVPN_DATA
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

For every user (client) you want to give a certificate to run:

```
export CLIENTNAME="your_client_name"
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
```

### Connect

Host: `[smb:]\\<ip address or host>\vault`

## Reference

* http://manpages.ubuntu.com/manpages/xenial/man5/smb.conf.5.html

* https://askubuntu.com/questions/751034/how-do-i-share-samba-via-open-vpn-is-that-possible
