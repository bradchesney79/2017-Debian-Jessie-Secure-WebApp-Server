printf "\n\n##### Beginning 02100-install-front-end-tools.sh\n\n" >> /root/report/build-report.txt

# ToDo: inject setup.conf variables and fix key:value pair values
# ToDo: set front-end testing information
cat <<EOF > $PROJECTROOT/package.json
{
  "name": "kingchesney",
  "version": "1.0.0",
  "description": "the front-end dependencies for the website",
  "main": "index.js",
  "dependencies": {
    "@angular/animations": "^4.1.3",
    "@angular/common": "^4.1.3",
    "@angular/compiler": "^4.1.3",
    "@angular/compiler-cli": "^4.1.3",
    "@angular/core": "^4.1.3",
    "@angular/forms": "^4.1.3",
    "@angular/http": "^4.1.3",
    "@angular/platform-browser": "^4.1.3",
    "@angular/platform-browser-dynamic": "^4.1.3",
    "@angular/platform-server": "^4.1.3",
    "@angular/router": "^4.1.3",
    "typescript": "^2.3.3"
  },
  "devDependencies": {
    "webpack": "^2.6.0",
    "jasmine": "^2.6.0"
  },
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "user1001",
  "license": "ISC"
}
EOF

cd $PROJECTROOT

if [ "$DEV" = "true" ]
  then
    npm install

else

  npm install --production

fi

