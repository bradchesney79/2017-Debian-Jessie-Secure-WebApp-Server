printf "\n\n##### Beginning 01900-install-nodejs.sh\n\n" >> /root/report/build-report.txt


## Install nvm -- this gives me the willies
## ToDo: Rig up some kind of checksum checking logic here
#mkdir -p ${PROJECTROOT}/tmp/node
#
#curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh > ${PROJECTROOT}/tmp/node/install.js
#
#chmod 700 ${PROJECTROOT}/tmp/node/install.js
#
#${PROJECTROOT}/tmp/node/install.js
#
## Load nvm
## ToDo: Fix this, this isn't right-- this should be under the webuser
#chmod 700 /root/.nvm/nvm.sh
#. /root/.nvm/nvm.sh
#
## Install nodejs (I install more than I need to prevent warning messages: iojs & argon)
#nvm install iojs
#nvm install argon
#
## Most recent LTS release
#nvm install v6.11.2
#
## Latest version
#nvm install v8.4.0
#
## Set LTS version as active
#nvm alias default v6.10.3

# install nodejs
curl -L https://git.io/n-install | N_PREFIX=~/opt/n bash -s -- -y

cat <<"EOF" > ${HOME}/.bashrc
# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# Added by n-install (see http://git.io/n-install-repo)
# Then tweaked to put node in the /opt directory
# ToDo: add these lines to etc/skel so all accounts get it
export N_PREFIX="/opt/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"


export PATH=/opt/.npm-global/node/bin:$PATH
EOF



mkdir -p /opt/.npm-global/node/

cp -R "${HOME}/opt/n/" "/opt/n/"

rm -rf "${HOME}/opt/n/"

npm config set prefix "/opt/n/.npm-global"
N_PREFIX=/opt/n/.npm-global/node
PATH=/opt/n/.npm-global/node/bin:$PATH

# Make the prefix available now

. "${HOME}/.bashrc"

# 777 works... let's try 775
chmod -r 775 /opt/n

n stable # install this version, set to default, & switch to it

n  -d lts # download only