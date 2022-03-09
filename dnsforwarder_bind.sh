echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
apt-get update -y
apt-get upgrade -y
apt-get install bind9 bind9utils bind9-doc -y

touch /etc/bind/named.conf.options
cat << EOF > /etc/bind/named.conf.options

acl privateips {
    	10.0.0.0/8;
    	172.16.0.0/12;
    	192.168.0.0/16;
        localhost;
        localnets;
};

options {
        directory "/var/cache/bind";

        recursion yes;
        allow-query { privateips; };

        forwarders {
                168.63.129.16;
        };
        forward only;
        
        dnssec-validation no;

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
EOF

sudo named-checkconf /etc/bind/named.conf.local

sudo ufw allow in ssh
sudo ufw allow from any to any port 53 proto tcp
sudo ufw allow from any to any port 53 proto udp

sudo systemctl enable named
sudo systemctl restart named
