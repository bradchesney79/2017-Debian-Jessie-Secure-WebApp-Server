printf "\n\n##### Beginning 02100-install-front-end-tools.sh\n\n" >> /root/report/build-report.txt

# ToDo: set front-end testing information
cat <<EOF > $PROJECTROOT/package.json
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

cd $PROJECTROOT

if [ "$DEV" = "true" ]
  then
    npm install

else

  npm install --production

fi

