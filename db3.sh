#!/bin/sh

main() {
    sed -i -e 's/us.archive.ubuntu.com/jp.archive.ubuntu.com/' /etc/apt/sources.list

    apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

    cat > /etc/apt/apt.conf <<EOF
Acquire::http::Proxy "http://proxy.hinet.net:80";
EOF

    cat > /etc/apt/sources.list.d/percona.list <<EOF
deb http://repo.percona.com/apt precise main
deb-src http://repo.percona.com/apt precise main
EOF

    apt-get update

    DEBIAN_FRONTEND=noninteractive apt-get -y install dstat vim-nox
    DEBIAN_FRONTEND=noninteractive apt-get -y install percona-xtradb-cluster-garbd-2

    cat > /etc/rc.local <<EOF
#
/usr/bin/garbd -d -a gcomm://192.168.50.101:4567 -g test -l /tmp/garbd-test.log
exit 0
EOF

    while true; do
        nc -w 1 192.168.50.101 3306 && break
        sleep 1
    done

    /usr/bin/garbd -d -a gcomm://192.168.50.101:4567 -g test -l /tmp/garbd-test.log > /dev/null 2>&1 &
}

main > /tmp/boot.log 2>&1 &
