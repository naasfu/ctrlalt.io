require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/puma'
require 'mina/scp'
require 'highline/import'

###
### TASKS
################################################################################


require_relative 'deploy/essentials'
require_relative 'deploy/setup'
require_relative 'deploy/imagemagick'
require_relative 'deploy/postgresql'
require_relative 'deploy/nodejs'
require_relative 'deploy/redis'
require_relative 'deploy/rbenv'
require_relative 'deploy/puma'
require_relative 'deploy/nginx'
require_relative 'deploy/paypal'
require_relative 'deploy/secrets'
require_relative 'deploy/sidekiq'


###
### SERVER
################################################################################

set :domain,               '159.203.254.200'
set :user,                 'deployer'
set :forward_agent,         true 

set :app_name,             'ctrlalt'
set :app_root,             '/Users/codyeatworld/rails/ctrlalt-v2/'
set :template_path,        '/Users/codyeatworld/rails/ctrlalt-v2/config/deploy/templates'
set :deploy_to,            "/home/#{user}/#{app_name}"

set :repository,           'git@github.com:codyeatworld/ctrlalt-v2.git'
set :branch,               'master'

set :shared_paths,         ['config/database.yml', 'config/application.yml', 'config/secrets.yml', 'log', 'public/uploads', 'tmp', 'certs/paypal']

task :environment do                                                                                                                                                                                              
  invoke :'rbenv:load'
end

###
### MINA DEPLOY
################################################################################

desc "Restart services"
task :restart do
  invoke :'nginx:reload'
  invoke :'nginx:restart'
  invoke :'puma:restart'
  invoke :'sidekiq:start'
end

desc "Deploys the current version to the server."
task deploy: :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end

  deploy do
    invoke :'rbenv:load'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    invoke :'secrets:upload'

    to :launch do
      invoke :'puma:restart'
      invoke :'sidekiq:start'
    end
  end
end

# ssh root@<server>
# adduser deployer
# echo "deployer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# exit
# ssh-copy-id deployer@<server>
# mina setup
# mina provision:essentials
# mina provision:imagemagick
# mina provision:nodejs
# mina provision:redis
# mina provision:nginx
# mina provision:postgresql
# mina provision:rbenv