FROM alpine:3.7

MAINTAINER Pawel Urawski

RUN apk update && \
    apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash-completion krb5 samba-dc bind shadow openrc coreutils && \
    rm -rf /var/cache/apk/* && \
    rm /etc/samba/smb.conf

VOLUME /etc/samba

EXPOSE 137/udp 138/udp 139 445
COPY sleepi.sh /
#CMD ["/bin/sh"]
CMD ["/sleepi.sh"]