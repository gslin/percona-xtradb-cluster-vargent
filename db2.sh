#!/bin/sh

main() {
    sed -i -e 's/us.archive.ubuntu.com/jp.archive.ubuntu.com/' /etc/apt/sources.list

    apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

    nc -w 1 proxy.hinet.net 80 && cat > /etc/apt/apt.conf <<EOF
Acquire::http::Proxy "http://proxy.hinet.net:80";
EOF

    cat > /etc/apt/sources.list.d/percona.list <<EOF
deb http://repo.percona.com/apt precise main
deb-src http://repo.percona.com/apt precise main
EOF

    apt-get -V update

    DEBIAN_FRONTEND=noninteractive apt-get -Vy install dstat vim-nox
    DEBIAN_FRONTEND=noninteractive apt-get -Vy install percona-xtradb-cluster-server-5.5 xtrabackup

    service mysql stop

    mkdir -p /srv/mysql /srv/tmp
    chmod 1777 /srv/tmp

    rm -rf /var/lib/mysql
    ln -s /srv/mysql /var/lib/mysql

    mysql_install_db
    chown -R mysql:mysql /srv/mysql

    cat > /etc/mysql/my.cnf <<EOF
#
[mysqld]
binlog_format = ROW
character_set_server = utf8mb4
collation_server = utf8mb4_general_ci
datadir = /var/lib/mysql
default_storage_engine = InnoDB
expire_logs_days = 7
innodb_autoinc_lock_mode = 2
innodb_buffer_pool_size = 64M
innodb_data_file_path = ibdata1:64M;ibdata2:64M:autoextend
innodb_file_format = Barracuda
innodb_file_per_table
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
innodb_locks_unsafe_for_binlog = 1
innodb_log_file_size = 64M
innodb_print_all_deadlocks = 1
innodb_stats_on_metadata = FALSE
innodb_support_xa = FALSE
log-bin = mysqld-bin
log-queries-not-using-indexes
log-slave-updates
long_query_time = 1
max_connect_errors = 4294967295
max_connections = 32
port = 3306
relay_log_recovery = TRUE
skip-name-resolve
slow_query_log = 1
tmpdir = /srv/tmp
transaction_isolation = REPEATABLE-READ
user = mysql
wait_timeout = 60
#
# Galera
wsrep_cluster_address = gcomm://192.168.50.101:4567,192.168.50.102:4567,192.168.50.103:4567
wsrep_cluster_name = test
wsrep_node_address = 192.168.50.102
wsrep_provider = /usr/lib/libgalera_smm.so
wsrep_provider_options = "gcache.size=16M"
wsrep_slave_threads = 4
wsrep_sst_auth = "root:"
wsrep_sst_method = xtrabackup
#
server-id = 2
EOF

    while true; do
        nc -w 1 192.168.50.101 3306 && break
        sleep 1
    done

    /etc/init.d/mysql start
}

main > /tmp/boot.log 2>&1 &
