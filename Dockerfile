FROM ubuntu:18.04

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y samba

COPY image/etc/samba/smb.conf /etc/samba/smb.conf

CMD service smbd restart
