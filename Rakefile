#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Slotcars::Application.load_tasks

# load environment specific seed files on rake db:seed
namespace :db do
  task :seed => :environment do
    env_seed_file = File.join(Rails.root, 'db', 'seeds', "#{Rails.env}.rb")
    load(env_seed_file) if File.exist?(env_seed_file)
  end
end