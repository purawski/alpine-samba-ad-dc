FROM alpine:3.7

MAINTAINER Pawel Urawski

RUN apk update && \
    apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash-completion \
    krb5 krb5-server samba-dc bind bind-tools \
    shadow coreutils ldb-tools supervisor \
    pwgen \
    acl-dev \
    attr-dev \
    blkid \
    gnutls-dev \
    readline-dev \
    python-dev \
    linux-pam-dev \
    py-pip \
    popt-dev \
    openldap-dev \
    libbsd-dev \
    cups-dev \
    ca-certificates \
    py-certifi \
    rsyslog \
    expect \
    tdb \
    tdb-dev \
    py-tdb \
    && \
    rm -rf /var/cache/apk/* && \
    rm /etc/samba/smb.conf

VOLUME ["/etc/samba","/var/lib/samba"]

EXPOSE 137/udp 138/udp 139 445
COPY sleepi.sh /
COPY init.sh /
#CMD ["/bin/sh"]
CMD ["/init.sh"]