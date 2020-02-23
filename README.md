# docker-vpn-samba

Turn-key Samba (SMB) file share and VPN. Setup a secure file share behind VPN in minutes. 

## How It Works

Docker and Compose are leveraged to quickly standup a VPN and Samba (SMB) server that is lightweight, portable, and powerful. The Samba server can only be accessed once you're logged onto the VPN. Set this up on many cloud providers like AWS, GCP, Azure, DigitalOcean, Linode, etc or your home or business network to quickly and securely share files of nearly any size with nearly any amount of users, the limit is what your hardware can provide.

## Getting Started

Example below is a fresh Ubuntu 18.04 LTS server in the cloud.

### Prerequisites

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

### Configure Server Variables

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

#### Note

If you have existing files in the share directory before this server was ever started, set the permissions to 777 so they can be writeable

```
chmod -Rv 777 $DVS_LOCAL_SHARE_PATH
```

### Add Users To VPN

Setup the VPN credential directory:

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
sed -i '/redirect-gateway def1/d' $DVS_LOCAL_VPN_CREDS_PATH/$CLIENTNAME-vault.ovpn
echo "route-nopull" >> $DVS_LOCAL_VPN_CREDS_PATH/$CLIENTNAME-vault.ovpn
echo "route 172.28.28.28 255.255.255.255" >> $DVS_LOCAL_VPN_CREDS_PATH/$CLIENTNAME-vault.ovpn
```
#### Download Credentials

Access the files here and download them to distribute to your intended users:

```
cd $DVS_LOCAL_VPN_CREDS_PATH
```

### Connect To VPN Server

Users can download and run any common OpenVPN client for Windows, MacOS, Linux, Android, iOS, etc.

Import the *.ovpn file into the client software of your choice. Connect with the file and password from adding the user in a previous step.

Have the user connect their client VPN to the server.

### Connect To Samba File Share Inside VPN

Windows and MacOS provide built-in mechanisms for connecting to Samba file shares. Linux, iOS, and Android will require an app and/or additional configuration but should work fine as well. 

#### Credentials

Host: `\\172.28.28.28\vault`

The Samba share is configured to not ask for a username or password and you should not be prompted for one.

## Reference

* https://github.com/kylemanna/docker-openvpn

* http://manpages.ubuntu.com/manpages/xenial/man5/smb.conf.5.html

* https://askubuntu.com/questions/751034/how-do-i-share-samba-via-open-vpn-is-that-possible
