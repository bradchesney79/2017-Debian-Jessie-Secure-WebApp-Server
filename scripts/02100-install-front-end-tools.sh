printf "\n\n##### Beginning 02100-install-front-end-tools.sh\n\n" >> /root/report/build-report.txt

mkdir -p $PROJECTROOT/dist

read -rsp $'Press any key to continue (created dist dir)...\n' -n 1

# ToDo: set front-end testing information
cat <<EOF > $PROJECTROOT/dist/package.json
{
  "name": "$LOWERCASEPROJECTNAME",
  "version": "$VERSION",
  "description": "$DESCRIPTION",
  "main": "index.js",
  "dependencies": {
    "@angular/animations": "^4.3.6",
    "@angular/cdk": "^2.0.0-beta.8",
    "@angular/cli": "^1.3.2",
    "@angular/common": "^4.3.6",
    "@angular/core": "^4.3.6",
    "@angular/material": "^2.0.0-beta.8",
    "hammerjs": "^2.0.8"
  },
  "devDependencies": {},
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "repository": {
    "type": "git",
    "url": "$GITREPO"
  },
  "keywords": [
    $PROJECTKEYWORDS
  ],
  "author": "$USERID1001",
  "license": "ISC",
  "bugs": {
    "url": "$BUGREPORTING"
  },
  "homepage": "$PROJECTINFOURL"
}
EOF
read -rsp $'Press any key to continue (wrote package.json)...\n' -n 1

cd $PROJECTROOT/dist

read -rsp $'Press any key to continue (cd dist dir)...\n' -n 1

mkdir -p /opt/n/lib/node_modules/@angular/cli/node_modules/node-sass/vendor

read -rsp $'Press any key to continue (created node-sass/vendor dir)...\n' -n 1

chmod -R 777 /opt/n

read -rsp $'Press any key to continue (all permissions on /opt/n)...\n' -n 1

if [ "$DEV" = "true" ]
  then
    npm install

    read -rsp $'Press any key to continue (dev npm install)...\n' -n 1

    npm install -g @angular/cli

    read -rsp $'Press any key to continue (npm install -g angular/cli)...\n' -n 1
else

  # install app depencencies

  npm install --production

  # ToDo pull in compiled front end app code from dev repo or something

fi

