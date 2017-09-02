printf "\n\n##### Beginning 01900-install-nodejs.sh\n\n" >> /root/report/build-report.txt


## Install n -- this gives me the willies

cd $PROJECTROOT

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


export PATH=/opt/n/.npm-global/node/bin:$PATH
EOF



mkdir -p /opt/n/.npm-global/node

cp -R "${HOME}/opt/n" "/opt/"

rm -rf "${HOME}/opt/n/"

N_PREFIX=/opt/n/.npm-global/node >> /etc/environment
export N_PREFIX=/opt/n/.npm-global/node

PATH=/opt/n/.npm-global/node/bin:$PATH  >> /etc/environment
export PATH=/opt/n/.npm-global/node/bin:$PATH

# Make the prefix available now

. "${HOME}/.bashrc"

chmod -R 777 /opt/n

n stable # install this version, set to default, & switch to it

n  -d lts # download only

npm config set prefix "/opt/n/.npm-global"