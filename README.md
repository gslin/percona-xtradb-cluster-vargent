Percona XtraDB Cluster 5.5 Vagrantfile
======================================

Overview
--------

This <code>Vagrantfile</code> will build a PXC 5.5 cluster (three VMs), and you can try PXC operation in this cluster.

Configuration
-------------

It will setup APT proxy to http://proxy.hinet.net:80 (HiNet Proxy) to accelerate downloading speed.  If you are not in HiNet network, remove this setting from <code>db[123].sh</code>.

Base system will be <code>hashicorp/precise64</code>, which is based on Ubuntu 12.04 LTS.

Network settings will be:

1. db1 (eth1, 192.168.50.101)
2. db2 (eth1, 192.168.50.102)
3. db3 (eth1, 192.168.50.103)

eth0 will be NAT.

Running PXC
-----------

1. db1

   You need to use <code>bootstrap-pxc</code> to initialize on first node:

   <code>/etc/init.d/mysql bootstrap-pxc</code>

2. db2

   Once db1 is up, you can use normal command to join cluster:

   <code>/etc/init.d/mysql start</code>

3. db3

   Once db1 is up, you can use this command to join cluster:

   <code>/etc/rc.local</code>

Confirm
-------

In db1 and db2, run:

<code>mysql -u root</code>

Then,

<code>SHOW STATUS LIKE 'wsrep_%'</code>

You might see:

<pre>
+----------------------------+------------------------------------------+
| Variable_name              | Value                                    |
+----------------------------+------------------------------------------+
| wsrep_local_state_uuid     | 3c1ffcfb-dc10-11e3-b0f4-e2bc3c0b6171     |
| wsrep_protocol_version     | 4                                        |
| wsrep_last_committed       | 0                                        |
| wsrep_replicated           | 0                                        |
| wsrep_replicated_bytes     | 0                                        |
| wsrep_received             | 10                                       |
| wsrep_received_bytes       | 649                                      |
| wsrep_local_commits        | 0                                        |
| wsrep_local_cert_failures  | 0                                        |
| wsrep_local_replays        | 0                                        |
| wsrep_local_send_queue     | 0                                        |
| wsrep_local_send_queue_avg | 0.000000                                 |
| wsrep_local_recv_queue     | 0                                        |
| wsrep_local_recv_queue_avg | 0.000000                                 |
| wsrep_flow_control_paused  | 0.000000                                 |
| wsrep_flow_control_sent    | 0                                        |
| wsrep_flow_control_recv    | 0                                        |
| wsrep_cert_deps_distance   | 0.000000                                 |
| wsrep_apply_oooe           | 0.000000                                 |
| wsrep_apply_oool           | 0.000000                                 |
| wsrep_apply_window         | 0.000000                                 |
| wsrep_commit_oooe          | 0.000000                                 |
| wsrep_commit_oool          | 0.000000                                 |
| wsrep_commit_window        | 0.000000                                 |
| wsrep_local_state          | 4                                        |
| wsrep_local_state_comment  | Synced                                   |
| wsrep_cert_index_size      | 0                                        |
| wsrep_causal_reads         | 0                                        |
| wsrep_incoming_addresses   | ,192.168.50.101:3306,192.168.50.102:3306 |
| wsrep_cluster_conf_id      | 3                                        |
| wsrep_cluster_size         | 3                                        |
| wsrep_cluster_state_uuid   | 3c1ffcfb-dc10-11e3-b0f4-e2bc3c0b6171     |
| wsrep_cluster_status       | Primary                                  |
| wsrep_connected            | ON                                       |
| wsrep_local_bf_aborts      | 0                                        |
| wsrep_local_index          | 1                                        |
| wsrep_provider_name        | Galera                                   |
| wsrep_provider_vendor      | Codership Oy &lt;info@codership.com>        |
| wsrep_provider_version     | 2.10(r175)                               |
| wsrep_ready                | ON                                       |
+----------------------------+------------------------------------------+
40 rows in set (0.00 sec)
</pre>

You can see <code>wsrep_cluster_size</code> is 3, which means successful.
