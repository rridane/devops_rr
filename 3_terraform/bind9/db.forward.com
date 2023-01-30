;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA ns.rr-dev.local. root.localhost. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@           IN      NS      ns.rr-dev.local.
ns          IN      A       10.10.10.53
nextcloud   IN      A       10.10.10.108
ldap        IN      A       10.10.10.110
