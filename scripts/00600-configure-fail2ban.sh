printf "\n\n##### Beginning 00600-configure-fail2ban.sh\n\n" >> /root/report/build-report.sh

printf "\n## SETTING FAIL2BAN CONFIGURATION ###\n"

cat <<EOF /etc/fail2ban/jail.local
[ssh-iptables]
enabled  = true
filter   = sshd
action   = iptables-multiport-log[name=SSH, port=ssh, protocol=tcp]
      sendmail-whois[name=SSH, dest=$TARGETEMAIL, sender=fail2ban@$HOSTNAME.$DOMAIN, sendername="Fail2Ban"]
logpath  = /var/log/secure
maxretry = 5
bantime  = 604800
EOF
