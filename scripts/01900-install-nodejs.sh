printf "\n\n##### Beginning 01900-install-nodejs.sh\n\n" >> /root/report/build-report.txt


# Install nvm -- this gives me the willies
# ToDo: Rig up some kind of checksum checking logic here
mkdir -p $PROJECTROOT/tmp/node

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh > $PROJECTROOT/tmp/node/install.js

chmod 700 $PROJECTROOT/tmp/node/install.js

/root/tmp/node/install.js

# Load nvm
# ToDo: Fix this, this isn't right-- this should be under the webuser
chmod 700 /root/.nvm/nvm.sh
. /root/.nvm/nvm.sh

# Install nodejs (I install more than I need to prevent warning messages: iojs & argon)
nvm install iojs
nvm install argon

# Most recent LTS release
nvm install v6.11.2

# Latest version
nvm install v8.4.0

# Set LTS version as active
nvm alias default v6.10.3

npm install -g npm

# Change the npm default directory

mkdir -p $PROJECTROOT/.npm-global

echo "NPM_CONFIG_PREFIX=${PROJECTROOT}/.npm-global" >> /etc/environment

# Make it available now

npm config set prefix ${PROJECTROOT}/.npm-global

export PATH=${PROJECTROOT}/.npm-global/bin:${PATH}


