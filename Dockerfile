FROM ubuntu:18.04

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y samba

COPY image/etc/samba/smb.conf /etc/samba/smb.conf

COPY image/usr/bin/run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

ENTRYPOINT /usr/bin/run.sh
