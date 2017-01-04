# 2017-Debian-Jessie-Secure-WebApp-Server

I am facing a really neat and exciting fundamental change to how I've done autoloading-- I thought I'd be working on this next month. However, my situation has changed and I need to know the up to date now context of modern way of doing things well enough to teach it. So here we are.

This is the 2017 version updated using the things I learned from the 2015 version

A setup script for a Debian LAMP Webserver. Building with a security focus & geared towards higher performance than stock configuration that should run well everywhere-- considering that if we dumped all this shenanigans on a stock host it would possibly get bogged down.

Initially this will be in implemented with bash until I arrive at an end result I am happy with.

I will use the bash script as a roadmap to build an Ansible playbook.

Bear in mind this is very much "in progress".

How to use this on a very basic level:

#1 Start up a blank linode, initially provision it with Debian 8.1

(If you are a new VPS person one way or another to linode and want to do me a solid, this is my referral code, 47a784faf04635f5f0cc532168f534fdde765000. Thanks.)

#2 SSH into the machine

#3 cut/paste this mess into the command line:

We are supplying a user agent string as Chrome on Linux. Think about someone conditionally supplying content based on the information you are giving to the remote host and then disguising to the receiving server that you may be doing more than just browsing the source code.

curl -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36" https://raw.githubusercontent.com/bradchesney79/2017-Debian-Jessie-Secure-WebApp-Server/master/init.sh | sh

#4 set up a junk email service, I reccomend http://33mail.com -- they even have a configuration for people like us in the works

#5 edit setup.conf with your hosts' particulars

You can almost use it as it is, if you just want to see it go, but you'll need to edit a few things:

IPV4=<your linode IPV4 address>

IPV6=<your linode IPV6 address>

TARGETEMAIL=<your email with the junk email service>

[What is my linode IP?](https://www.linode.com/docs/getting-started#finding-the-ip-address)

#6 then cut/paste this in the command line to run these two scripts:

. /root/bin/build-script.sh && . /root/bin/load-script.sh

#7 you can hit the host by navigating to the IP address with your browser at the very least (or your domain name if setup)

TODO:

finish configuring sentinel

configure global webdev resources like composer, node, fonts to run tests & builds

improve troubleshooting resources

remedy broken GUI SFTP -- works fine CLI

update troubleshooting resources on github

improve readability

break into modular Ansible scripts

NICE TO HAVE:

disk partitions

THANKS:

simplified logging - http://reddit.com/user/cheaphomemadeacid

reminder that my instructions sucked - https://www.reddit.com/user/iAMthePRONY

For me to test the whole thing as-is:

linode rebuild rust-belt-rebellion --distribution "Debian 8" --password "ffff4444"; printf 'curl https://raw.githubusercontent.com/bradchesney79/2017-Debian-Jessie-Secure-WebApp-Server/master/init.sh | /bin/bash && cd /root/bin && . /root/bin/build-script.sh'

curl https://raw.githubusercontent.com/bradchesney79/2017-Debian-Jessie-Secure-WebApp-Server/master/init.sh | /bin/bash && cd /root/bin && . /root/bin/build-script.sh && . /root/bin/load-script.sh

