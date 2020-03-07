# docker-vpn-samba

Turn-key Samba (SMB) file share and VPN. Setup a secure file share behind VPN in minutes. 

## How It Works

Docker and Compose are leveraged to quickly standup a VPN and Samba (SMB) server that is lightweight, portable, and powerful. The Samba server can only be accessed once you're logged onto the VPN. Set this up on many cloud providers like AWS, GCP, Azure, DigitalOcean, Linode, etc or your home or business network to quickly and securely share files of nearly any size with nearly any amount of users, the limit is what your hardware can provide.

## Getting Started

Example below is a fresh Ubuntu 18.04 LTS server in the cloud.

### Setup

```
git clone https://github.com/dantheman213/docker-vpn-samba
cd docker-vpn-samba/bin
./setup.sh vpn.mydomain.com
```

1. Enter a passphrase, make sure it's a long secure string, and keep it safe

2. You will then be prompted to enter the server host, enter $DVS_VPN_HOST value above

3. Provide the passphrase from #1 in (2) prompts

### Start Containers

```
./start.sh
```

### Add Users To VPN

For every user (client) you want to give a certificate to run:

```
./create-user.sh bob.sampleton
```

1. You will be asked for key to create user, create new key not the same as CA passphrase
2. You will be asked to provide the CA key from earlier, provide to generate the key

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
