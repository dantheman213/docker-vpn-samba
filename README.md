# docker-vpn-samba

Turn-key Samba (SMB) file share and VPN

## Getting Started

Setup a secure file share behind VPN in minutes. Example below is a fresh Ubuntu 18.04 LTS server in the cloud.

### Prereq

```
apt-get update
apt-get upgrade -y
apt-get install -y docker docker-compose

ufw default deny incoming
ufw allow 22
ufw allow 1194/udp
ufw enable

git clone https://github.com/dantheman213/docker-vpn-samba
cd docker-vpn-samba
```

### Setup

Set these values custom to your preference on your new server.

```
echo "export DVS_LOCAL_VPN_CONFIG_PATH=/etc/openvpn" >> /etc/environment
echo "export DVS_LOCAL_VPN_CREDS_PATH=/etc/vpn/credentials" >> /etc/environment
echo "export DVS_LOCAL_SHARE_PATH=/samba" >> /etc/environment
echo "export DVS_VPN_HOST=vpn.mydomain.com" >> /etc/environment
source /etc/environment
```

Now run this code one at a time to continue setup:

```
[ ! -d $DVS_LOCAL_SHARE_PATH ] && mkdir -p $DVS_LOCAL_SHARE_PATH
chmod 777 $DVS_LOCAL_SHARE_PATH

[ ! -d $DVS_LOCAL_VPN_CONFIG_PATH ] && mkdir -p $DVS_LOCAL_VPN_CONFIG_PATH
docker-compose run --rm openvpn ovpn_genconfig -u udp://$DVS_VPN_HOST
docker-compose run --rm openvpn ovpn_initpki
```

1. Enter a passphrase, make sure it's a long secure string, and keep it safe

2. You will then be prompted to enter the server host, enter $DVS_VPN_HOST value above

3. Provide the passphrase from #1 in (2) prompts

### Start Containers
```
docker-compose up --build -d
```

### Configure Authentication

```
[ ! -d $DVS_LOCAL_VPN_CREDS_PATH ] && mkdir -p $DVS_LOCAL_VPN_CREDS_PATH
```

For every user (client) you want to give a certificate to run:

```
export CLIENTNAME="bob.sampleton"
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
```

1. You will be asked for key to create user, create new key not the same as CA passphrase
2. You will be asked to provide the CA key from earlier, provide to generate the key

```
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $DVS_LOCAL_VPN_CREDS_PATH/$CLIENTNAME-vault.ovpn
```

### Connect Client To VPN Server

Download the *.ovpn client files you generated earlier and share them with all of the user(s). The users can use any regular OpenVPN client for Windows, MacOS, Linux, Android, iOS, etc.

Import the *.ovpn file into the client software of your choice and connect with the file and password provided when generating the file.

Connect to the VPN.

### Connect To Samba File Share

Windows and MacOS provide built-in mechanisms for connecting to Samba file shares. Linux, iOS, and Android will require an app and/or additional configuration but should work fine as well. 

#### Credentials

Host: `\\172.28.28.28\vault`
Username guest (or any username really)
Password <empty>

### Disconnect

The VPN currently sends all traffic over it so disconnect after using the Samba file share in order to resume normal Internet activities.

## Reference

* https://github.com/kylemanna/docker-openvpn

* http://manpages.ubuntu.com/manpages/xenial/man5/smb.conf.5.html

* https://askubuntu.com/questions/751034/how-do-i-share-samba-via-open-vpn-is-that-possible
