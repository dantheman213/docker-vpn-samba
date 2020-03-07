FROM ubuntu:18.04

RUN apt-get -y update && \
    apt-get install -y samba

COPY image/etc/samba/smb.conf /etc/samba/smb.conf

COPY image/usr/bin/run.sh /usr/bin/run.sh
RUN groupadd samba && \
    useradd samba -g samba -s /usr/sbin/nologin && \
    printf "samba\nsamba" | smbpasswd -a -s samba && \
    mkdir /samba && \
    chown samba:samba /samba && \
    chmod 777 /samba && \
    chmod +x /usr/bin/run.sh

ENTRYPOINT /usr/bin/run.sh
