FROM debian:latest

RUN apt-get update && apt-get -y install \
    autoconf \
    automake \
    autotools-dev \
    bash-completion \
    bison \
    build-essential \
    check \
    clang \
    cmake \
    comerr-dev \
    cpanminus \
    doxygen \
    debhelper \
    flex \
    g++ \
    git \
    gperf \
    graphviz \
    groff \
    texi2html \
    texinfo \
    heimdal-dev \
    help2man \
    libanyevent-perl \
    libbsd-dev \
    libbsd-resource-perl \
    libclone-perl \
    libconfig-inifiles-perl \
    libcunit1-dev \
    libdatetime-perl \
    libdb-dev \
    libdigest-sha-perl \
    libencode-imaputf7-perl \
    libfile-chdir-perl \
    libfile-slurp-perl \
    libglib2.0-dev \
    libio-socket-inet6-perl \
    libio-stringy-perl \
    libjson-perl \
    libjson-xs-perl \
    libldap2-dev \
    libmagic-dev \
    libmilter-dev \
    default-libmysqlclient-dev \
    libnet-server-perl \
    libnews-nntpclient-perl \
    libpath-tiny-perl \
    libpam0g-dev \
    libpcre3-dev \
    libsasl2-dev \
    libsnmp-dev \
    libsqlite3-dev \
    libssl1.0-dev \
    libstring-crc32-perl \
    libtest-deep-perl \
    libtest-deep-type-perl \
    libtest-most-perl \
    libtest-unit-perl \
    libtool \
    libunix-syslog-perl \
    liburi-perl \
    libxml-generator-perl \
    libxml-xpath-perl \
    libxml2-dev \
    libwrap0-dev \
    libxapian-dev \
    libzephyr-dev \
    lsb-base \
    net-tools \
    pandoc \
    perl \
    php-cli \
    php-curl \
    pkg-config \
    po-debconf \
    python-docutils \
    sudo \
    tcl-dev \
    transfig \
    uuid-dev \
    vim \
    wamerican \
    wget \
    xutils-dev \
    zlib1g-dev

RUN apt-get install "cmake" -y

# cyrus only logs to syslog, as far as I can tell, so we need it
# otherwise we will not have any idea what is going on.
RUN apt install -y rsyslog

RUN dpkg -l

RUN sed -r -i \
    -e 's/^"([^ ]|\s{2})(.*)$/\1\2/g' \
    -e 's/^set background=dark/"set background=dark/g' \
    /etc/vim/vimrc

RUN groupadd -r saslauth ; \
    groupadd -r mail ; \
    useradd -c "Cyrus IMAP Server" -d /var/lib/imap \
    -g mail -G saslauth -s /bin/bash -r cyrus

WORKDIR /srv
RUN git config --global http.sslverify false && \
    git clone https://github.com/cyrusimap/cyrus-imapd.git \
    cyrus-imapd.git

RUN git config --global http.sslverify false && \
    git clone https://github.com/cyrusimap/cyrus-docker.git \
    cyrus-docker.git

RUN git config --global http.sslverify false && \
    git clone https://github.com/cyrusimap/cyruslibs.git \
    cyruslibs.git

WORKDIR /srv/cyruslibs.git
RUN git fetch
RUN git checkout origin/master
RUN git submodule init
RUN git submodule update
RUN ./build.sh


ADD compile.sh /tmp/compile
RUN /tmp/compile && rm /tmp/compile

ADD cyrus.conf /etc/cyrus.conf
ADD imapd.conf /etc/imapd.conf
ADD /start.sh /start


RUN rm -rf /srv

WORKDIR /
CMD ["/start"]