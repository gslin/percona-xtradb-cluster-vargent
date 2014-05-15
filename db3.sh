#!/bin/sh

work() {
    sed -i -e 's/us.archive.ubuntu.com/jp.archive.ubuntu.com/' /etc/apt/sources.list

    apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

    cat > /etc/apt/sources.list.d/percona.list <<EOF
deb http://repo.percona.com/apt precise main
deb-src http://repo.percona.com/apt precise main
EOF

    DEBIAN_FRONTEND=noninteractive apt-get update

    DEBIAN_FRONTEND=noninteractive apt-get -y install dstat vim-nox
    DEBIAN_FRONTEND=noninteractive apt-get -y install percona-xtradb-cluster-galera-2.x

    cat >> /etc/rc.local <<EOF
/usr/bin/garbd -d -a gcomm://192.168.50.101 -g test -l /tmp/garbd-test.log
EOF
}

work &
