require 'bundler/capistrano'
require 'rvm/capistrano'
require 'airbrake/capistrano'

load 'deploy/assets'
load 'config/recipes/base'
load 'config/recipes/rvm'
load 'config/recipes/ffc'
load 'config/recipes/airbrake'
load 'config/recipes/mysql'
load 'config/recipes/bundle'
load 'config/recipes/passenger'

set :application,     'fat_free_crm'
set :user,            'create'
set :use_sudo,        false
set :deploy_to,       '/home/create/www/fat_free_crm'

server                'live.create.at', :app, :web, :db, primary: true
set :repository,      'git@github.com:create-mediadesign/fat_free_crm.git'
set :scm,             :git
set :branch,          'fulltext_search'

ssh_options[:forward_agent] = true
