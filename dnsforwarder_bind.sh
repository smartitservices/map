apt-get update
apt-get install bind9 bind9utils bind9-doc

touch /etc/bind/named.conf.options
cat << EOF > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";

        recursion yes;
        allow-query { goodclients; };

        forwarders {
                168.63.129.16;
        };

        dnssec-validation auto;

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
EOF

sudo bind9 -t && sudo service bind9 restart
