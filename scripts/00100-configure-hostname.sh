printf "\n\n##### Beginning 00100-configure-hostname.sh\n\n" >> /root/report/build-report.txt

printf "\n## SET THE HOSTNAME\n\n"

hostnamectl set-hostname $HOSTNAME

printf "\n## POPULATE THE HOSTS FILE ###\n"

cat <<EOF > /etc/hosts
127.0.0.1           localhost.localdomain localhost
127.0.1.1           debian
$IPV4               $HOSTNAME.$DOMAIN $HOSTNAME
# The following lines are desirable for IPv6 capable hosts
::1                 localhost ip6-localhost ip6-loopback
ff02::1             ip6-allnodes
ff02::2             ip6-allrouters
$IPV6               $HOSTNAME.$DOMAIN $HOSTNAME
EOF
