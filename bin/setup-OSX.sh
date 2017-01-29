#!/bin/bash

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew install sqlite
brew unlink autoconf
brew link autoconf
brew unlink pkg-config
brew link pkg-config
brew install rbenv
brew install ruby-build
git clone git@github.com:autolab/Autolab.git
cd Autolab
rbenv install $(cat .ruby-version)
echo “USER CHECK: Make sure the following two lines are …/ruby and …/rake”
which ruby
which rake
#echo "Are these correct? [Y/n]"
#read y
#if($y != "y" && $y != "Y"); then
#  echo "Terminating installation..."
#  exit
#else
#  echo "Proceeding with installation..."
#fi

yes() {
  echo "Proceeding with installation..."
}

no() {
  echo "Terminating installation..."
  exit
}

read -r -p "Are these correct? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        yes
        ;;
    *)
        no
        ;;
esac

gem install bundler
rbenv rehash
cd bin
bundle install
cd ..
cd config
sed -n '12,16p' < database.yml.template | sed -e "s/#//g" >> database.yml

log "Initializing Autolab configurations..."
    cp $AUTOLAB_PATH/config/database.yml.template $AUTOLAB_PATH/config/database.yml
    sed -i "s/<username>/$USER/g" $AUTOLAB_PATH/config/database.yml
gem install rake
gem install nokogiri
gem uninstall libv8
gem uninstall therubyracer
gem install libv8
gem install therubyracer
bundle install

bundle exec rake db:create
bundle exec rake db:reset
bundle exec rake db:migrate
bundle exec rake autolab:populate
