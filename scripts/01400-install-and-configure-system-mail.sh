printf "\n\n##### Beginning 01400-install-and-configure-system-mail\n\n" >> /root/report/build-report.txt

printf "\n## MAKE A SPF RECORD\n"

#### May need an SPF record
# from http://spfwizard.com

printf "\nSPF Record:" | tee -a /root/report/build-report.txt
printf "\n$DOMAIN.  IN TXT \"v=spf1 mx a ip4:$IPV4/32 ?all\"\n" | tee -a /root/report/build-report.txt

# in my DNS config the first text field was: rustbeltrebellion.com.
# in the dropdown: TXT
# in the last text field went: "v=spf1 mx a ip4:45.33.112.226/32 ?all"

#### Needed DMARC record
# https://www.unlocktheinbox.com/dmarcwizard/

printf "\nDMARC Record:" | tee -a /root/report/build-report.txt
printf "\n_dmarc.$DOMAIN. IN TXT \"v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:$USERID1001EMAIL; ruf=mailto:$USERID1001EMAIL; rf=afrf; pct=100; ri=604800\"\n" | tee -a /root/report/build-report.txt

# in my DNS config the first text field was: _dmarc.rustbeltrebellion.com.
# in the dropdown: TXT
# in the last text field went: "v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:bradchesney79@gmail.com; ruf=mailto:bradchesney79@gmail.com; rf=afrf; pct=100; ri=604800"

printf "\n## CREATE A DKIM CERTIFICATE\n"

apt-get -y install exim4 exim4-daemon-light bsd-mailx opendkim opendkim-tools mailutils

mkdir -p /var/www/certs/dkim
pushd /var/www/certs/dkim
openssl genrsa -out dkim.default.key 1024
openssl rsa -in dkim.default.key -out dkim.default.pub -pubout -outform PEM
popd

#TODO Don't forget to remind the user at the end to set this up externally to the server

DKIMPUBLICKEY=$(cat /var/www/certs/dkim/dkim.default.pub | sed -e s/"-.*"// | tr -d '\n')

printf "\nDKIM Certificate Record:" | tee -a /root/report/build-report.txt
printf "\ndefault._domainkey.$DOMAIN IN TXT \"v=DKIM1;p=$DKIMPUBLICKEY\"\n\n" | tee -a /root/report/build-report.txt

# in my DNS config the first text field was: default._domainkey..rustbeltrebellion.com.
# in the dropdown: TXT
# in the last text field went: "v=DKIM1;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC3xvSbgwX5WMMfIui3w2Lcwjj1RBVy/AjTCptQT4BGMRiLQcS5vhP4XnlzifX/G4Tp3oD+eh75zMLyw3mHjaT0dX1Yg79U/GAMndtkpoZaGMQwDKzKI0c0rt1AdmXHBEJ+BpPrG3IGGUN1H2eybyp4cZJ11ST51knk2mbSKooIPwIDAQAB"

printf "verify with this command:"
printf "\nhost -t txt default._domainkey.$DOMAIN default._domainkey.$DOMAIN descriptive text \"v=DKIM1\\;p=$DKIMPUBLICKEY" | tee -a /root/report/build-report.txt


# If not updating DNS for SPF but not DMARC or DKIM: still need to tell Google not to spam messages from:(*@$DOMAIN) via 'filters'
# Or use 3rd party disposable email forwarding


printf "\n## SET UPDATE-EXIM4.CONF MAIL CONFIGS\n"

cat <<EOF /etc/exim4/update-exim4.conf.conf
# /etc/exim4/update-exim4.conf.conf
#
# Edit this file and /etc/mailname by hand and execute update-exim4.conf
# yourself or use 'dpkg-reconfigure exim4-config'
#
# Please note that this is _not_ a dpkg-conffile and that automatic changes
# to this file might happen. The code handling this will honor your local
# changes, so this is usually fine, but will break local schemes that mess
# around with multiple versions of the file.
#
# update-exim4.conf uses this file to determine variable values to generate
# exim configuration macros for the configuration file.
#
# Most settings found in here do have corresponding questions in the
# Debconf configuration, but not all of them.
#
# This is a Debian specific file
printf "\n
dc_eximconfig_configtype='internet'
dc_other_hostnames='localhost'
dc_local_interfaces='127.0.0.1; ::1'
dc_readhost=''
dc_relay_domains=''
dc_minimaldns='false'
dc_relay_nets=''
dc_smarthost=''
CFILEMODE='644'
dc_use_split_config='false'
dc_hide_mailname=''
dc_mailname_in_oh='true'
dc_localdelivery='maildir_home'
EOF


#EOF is in quotes because I do not want any bash expansion of variables

cat <<"EOF" /etc/exim4/conf.d/main/00_localmacros
DKIM_CANON = strict
DKIM_SELECTOR = default
DKIM_PRIVATE_KEY = /var/www/certs/dkim/dkim.default.key
DKIM_DOMAIN = ${lc:${domain:$h_from:}}
EOF

printf "\n## SET EXIM4 MAILNAME\n"

printf "$DOMAIN" > /etc/mailname

printf "\n## REDIRECT SERVER MAIL TO A REAL WORLD ADDRESS\n"

sed -i "s/root:.*/root: $TARGETEMAIL/" /etc/aliases
printf "$USER: $TARGETEMAIL" >> /etc/aliases

printf "\n## APPLY CONFIGURATION CHANGES\n"

update-exim4.conf
newaliases

printf "\n## RESTART THE EXIM4 SERVICE\n"

systemctl restart exim4

printf "\n## SEND TEST MAIL\n"

printf "Email from $(hostname)" | mail "$TARGETEMAIL" -s "$DATE $UNIXTIMESTAMP Email from $(hostname)"

printf "\nNo DNS configuration mail testing:"
printf "\nThe trick is that you have to use 'disposable email' services that exist because in some cases it is not always the wisest decision to only do business with the best of the best. These services allow otherwise questionable mail to come in, melded into mail stamped as legit from a sender with sufficient SPF, DMARC, & DKIM-- and is sent along to your real mail box --or at least that is how it works with 33mail.com"
printf "\nWelcome to the seedy world of email laundering."
