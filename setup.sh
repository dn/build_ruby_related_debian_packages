#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Prepare system to build .deb packages and compile ruby
apt-get update -y
apt-get upgrade -y
apt-get install build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev ncurses-dev libyaml-dev libssl0.9.8 libyaml-0-2 libffi-dev libgdbm-dev -y
apt-get install ruby rubygems -y
gem1.8 install fpm --no-ri --no-rdoc


# Download ruby, compile it and make a package
wget ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p195.tar.gz -O /root/ruby-2.0.0-p195.tar.gz
cd /root
tar -zxvf ruby-2.0.0-p195.tar.gz
cd /root/ruby-2.0.0-p195
time (./configure --prefix=/opt/rubies/ruby-2.0.0-p195 && make && make install DESTDIR=/tmp/ruby)

## build the .deb
/usr/local/bin/fpm -s dir -t deb -n ruby -v 2.0.0-p195 --description "Self-packaged Ruby 2.0.0 patch 195" -C /tmp/ruby \
  -p ruby-VERSION_ARCH.deb -d "libstdc++6 (>= 4.4.3)" \
  -d "libc6 (>= 2.6)" -d "libffi6 (>= 3.0.4)" -d "libgdbm3 (>= 1.8.3)" \
  -d "libncurses5 (>= 5.7)" -d "libreadline6 (>= 6.1)" \
  -d "libssl0.9.8 (>= 0.9.8)" -d "zlib1g (>= 1:1.2.2)" \
  -d "libyaml-0-2 (>= 0.1.3)" \
  opt/rubies/ruby-2.0.0-p195

cp /root/ruby-2.0.0-p195/*.deb /home/vagrant

# Download chruby, compile it and make a package
cd /root
wget -O /root/chruby-0.3.5.tar.gz https://github.com/postmodern/chruby/archive/v0.3.5.tar.gz
tar -xzvf /root/chruby-0.3.5.tar.gz
cd /root/chruby-0.3.5/

mkdir /tmp/chruby/usr/local -p
mkdir /tmp/chruby/etc/profile.d/ -p
cp -r /root/chruby-0.3.5/bin /tmp/chruby/usr/local/
cp -r /root/chruby-0.3.5/share /tmp/chruby/usr/local

CHRUBY_CONFIG=`cat <<EOS
[ -n "\\\$BASH_VERSION" ] || [ -n "\\\$ZSH_VERSION" ] || return

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
EOS`
echo "$CHRUBY_CONFIG" > /tmp/chruby/etc/profile.d/chruby.sh

## build the .deb
/usr/local/bin/fpm -s dir -t deb -n chruby -v 0.3.5 --description "Self-packaged chruby 0.3.5" -C /tmp/chruby \
  -p chruby-VERSION_ARCH.deb \
  usr/local/share usr/local/bin etc/profile.d

cp /root/chruby-0.3.5/*.deb /home/vagrant
