#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

apt-get install build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev ncurses-dev libyaml-dev -y
apt-get install ruby rubygems -y
gem1.8 install fpm --no-ri --no-rdoc

wget ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p195.tar.gz -O /root/ruby-2.0.0-p195.tar.gz
cd /root
tar -zxvf ruby-2.0.0-p195.tar.gz
cd /root/ruby-2.0.0-p195
time (./configure --prefix=/usr && make && make install DESTDIR=/tmp/ruby200)

/usr/local/bin/fpm -s dir -t deb -n ruby200 -v 2.0.0-p195 --description "Self-packaged Ruby 2.0.0 patch 195" -C /tmp/ruby200 \
  -p ruby200-VERSION_ARCH.deb -d "libstdc++6 (>= 4.4.3)" \
  -d "libc6 (>= 2.6)" -d "libffi6 (>= 3.0.4)" -d "libgdbm3 (>= 1.8.3)" \
  -d "libncurses5 (>= 5.7)" -d "libreadline6 (>= 6.1)" \
  -d "libssl0.9.8 (>= 0.9.8)" -d "zlib1g (>= 1:1.2.2)" \
  -d "libyaml-0-2 (>= 0.1.3)" \
  usr/bin usr/lib usr/share/man usr/include
