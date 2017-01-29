#!/bin/bash

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew install sqlite
brew install rbenv
brew install ruby-build
git clone git@github.com:autolab/Autolab.git
cd Autolab
rbenv install $(cat .ruby-version)
echo “USER CHECK: Make sure the following two lines are …/ruby and …/rake”
which ruby
which rake
echo “Are these correct? [y/n]”
read y
if($y != ‘y’); then
  exit
else
fi

gem install bundler
rbenv rehash
cd bin
bundle install
cd ..
cd config
mv database.yml.template database.yml

log "Initializing Autolab configurations..."
    cp $AUTOLAB_PATH/config/database.yml.template $AUTOLAB_PATH/config/database.yml
    sed -i "s/<username>/$USER/g" $AUTOLAB_PATH/config/database.yml

bundle exec rake db:create
bundle exec rake db:reset
bundle exec rake db:migrate
bundle exec rake autolab:populate