FROM alpine:3.7

MAINTAINER Pawel Urawski

####################################################
########               GCC   and tools      ########
####################################################
# The GNU Compiler Collection 5.3.0-r0
 
RUN set -x \
    apk update && \
    apk --no-cache --no-progress upgrade \
    && apk add --no-cache \
        bash \
        gcc \
        curl \
        tar \
        alpine-sdk \
        linux-headers \
		libxml2-dev \
        openssl \
		openssl-dev \
        perl \
		libcap-dev \
        krb5-dev \
    && rm -rf /var/cache/apk/*   

####################################################
#########              BIND              ###########
####################################################

ENV BIND_VERSION 9.11.2

ENV CFLAGS "-O2 -m64"

ENV BUILD_OPTIONS "--enable-largefile \
                   --enable-fixed-rrset \
                   --enable-filter-aaaa \
                   --enable-ipv6 \
                   --enable-threads \
                   --enable-backtrace \
                   --enable-rpz-nsip \
                   --enable-rpz-nsdname \
                   --enable-rrl \
                   --enable-fetchlimit \
                   --enable-linux-caps \
                   --enable-shared \
                   --enable-static \
                   --with-dlopen=yes \
                   --with-readline=no \
                   --with-libtool \
                   --with-randomdev=/dev/random \
                   --sysconfdir=/etc/bind \
                   --with-openssl \
                   --with-libxml2 \      
                   --with-gssapi"
                   # --with-idn=$idnlib_dir"

# ENV OPEN_SSL 9.11.0
# ENV KERBEROS 9.11.0
# ENV LIBXML 9.11.0

ENV BIND_DIR /opt/bind

RUN set -x \
 && apk add --no-cache wget \
 && rm -rf /var/cache/apk/* \
 # && addgroup bind \
 # && adduser -D -S bind -s /bin/bash -h ${BIND_DIR} -g "BIND service user" -G bind \
 && mkdir -p ${BIND_DIR} \
 # && http://ftp.isc.org/isc/bind9/${_ver}/bind-${_ver}.tar.gz
 # && curl -L -O --insecure https://www.isc.org/downloads/file/bind-${BIND_VERSION}/?version=tar-gz \
 && wget --no-check-certificate -O bind-${BIND_VERSION}.tar.gz https://www.isc.org/downloads/file/bind-${BIND_VERSION}/?version=tar-gz \
 && tar xzf bind-${BIND_VERSION}.tar.gz  -C ${BIND_DIR} --strip-components=1 \
 && rm -rf bind-${BIND_VERSION}.tar.gz \
 # && chown -R bind:bind ${BIND_DIR} \
 && chmod +x ${BIND_DIR}/* \
 && cd ${BIND_DIR} \
 # && ./configure \
 && ./configure ${BUILD_OPTIONS} \
 && make clean \
 && make -j5 \
 # && make test \
 && make install \
 && rm -rf ${BIND_DIR} \
 && mkdir -p /etc/bind/dynamic \
 && mkdir -p /etc/bind/data \
 && touch /etc/bind/data/named.run

# named is at /usr/local/sbin

# Copy named.conf
COPY bind/* /etc/bind/



RUN apk update && \
    apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash-completion \
    krb5 krb5-server samba-dc \
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
#    openldap-dev \
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