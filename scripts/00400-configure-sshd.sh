printf "\n\n##### Beginning 00400-configure-sshd.sh\n\n" >> /root/report/build-report.txt

printf "\n## CONFIGURE SSH TO USE SUPPLEMENTAL ALGORITHMS ###\n"

# Todo: Permit root login, no
# Todo: MaxStartups should be tweaked, 3rd party lockout issue 

cat <<EOF > /etc/ssh/sshd_config
# Additional encryption algorithms for connecting via SSH
LoginGraceTime 30
PermitRootLogin yes
MaxStartups 3:50:10
AllowUsers root $USERID1001
KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1
EOF

systemctl restart sshd
