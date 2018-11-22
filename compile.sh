#/usr/bin.env sh

mkdir -p /usr/cyrus/bin
mkdir -p /var/lib/cyrus
mkdir -p /var/spool/cyrus/mail
mkdir -p /run/cyrus

chown -R cyrus:mail /var/lib/cyrus /run/cyrus /var/spool/cyrus


cd /srv/cyrus-imapd.git
git fetch
git checkout ${CYRUSBRANCH:-"origin/master"}
git clean -f -x -d

CFLAGS="-g -W -Wall -Wextra -Werror"
export CFLAGS

CONFIGOPTS="
    --enable-autocreate
    --enable-backup
    --enable-calalarmd
    --enable-gssapi
    --enable-http
    --enable-idled
    --enable-maintainer-mode
    --enable-murder
    --enable-nntp
    --enable-replication
    --enable-shared
    --enable-silent-rules
    --enable-unit-tests
    --enable-xapian
    --enable-jmap
    --with-ldap=/usr"

export CONFIGOPTS

./tools/build-with-cyruslibs.sh
