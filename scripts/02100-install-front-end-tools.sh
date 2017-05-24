printf "\n\n##### Beginning 02100-install-front-end-tools.sh\n\n" >> /root/report/build-report.txt

cd $PROJECTROOT

nvm install --save-dev webpack
