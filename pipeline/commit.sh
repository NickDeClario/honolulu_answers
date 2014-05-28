#!/bin/bash -e

ls -la $HOME
ls -la $HOME/.rvm
ls -la $HOME/.rvm/scripts
ls -la $HOME/.rvm/scripts/rvm

echo 0
source $HOME/.rvm/scripts/rvm
echo 1
rvm install ruby-1.9.3-p484
echo 2
gem install opendelivery bundler
echo 3
export SHA=`ruby -e 'require "opendelivery"' -e "puts OpenDelivery::Domain.new('$region').get_property '$sdb_domain','$pipeline_instance_id', 'SHA'"`
echo 4
echo checking out revision $SHA
git checkout $SHA
echo 5
export RAILS_ENV="test"
echo 6
export BHT_API_KEY="7868d47a7c43908cc80a44738acebb41"

echo 7
bundle install
echo 8
bundle exec rake db:drop
echo 9
bundle exec rake db:setup
echo 10
bundle exec rake spec

# Run static analysis
echo 11
gem install brakeman --version 2.1.1
echo 12
brakeman -o brakeman-output.tabs

echo 13
ruby -e 'require "opendelivery"' -e "OpenDelivery::Domain.new('$region').set_property '$sdb_domain','$pipeline_instance_id', 'furthest_pipeline_stage_completed', 'build'"
echo 14
ruby -e 'require "opendelivery"' -e "OpenDelivery::Domain.new('$region').set_property '$sdb_domain','$pipeline_instance_id', 'production_candidate', 'false'"
echo 15
