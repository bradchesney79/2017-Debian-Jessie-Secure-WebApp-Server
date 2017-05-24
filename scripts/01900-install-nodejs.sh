printf "\n\n##### Beginning 01900-install-nodejs.sh\n\n" >> /root/report/build-report.txt


# Install nvm -- this gives me the willies
#ToDo: Rig up some kind of checksum checking logic here
mkdir /tmp/node

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh > /tmp/node/install.js

chmod 700 /tmp/node/install.js

/tmp/node/install.sh

# Install nodejs (I install more than I need to prevent warning messages: iojs & argon)
nvm install iojs
nvm install argon

# Most recent LTS release
nvm install v6.10.3

# Latest version
nvm install v7.10.0

# Set LTS version as active
nvm use v6.10.3


npm install -g npm


