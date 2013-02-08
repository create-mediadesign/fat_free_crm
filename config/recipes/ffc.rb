namespace :ffc do
  desc 'Generate fat free crm configuration app files.'
  task :setup, :roles => :app do
    config   'settings.default.yml', "#{shared_path}/config/settings.yml"
    template 'secret_token.rb.erb',  "#{shared_path}/config/initializers/secret_token.rb"
  end
  after 'deploy:setup', 'ffc:setup'
  
  desc 'Symlink redmine configuration app files.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml"
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end
  after 'deploy:finalize_update', 'ffc:symlink'
end
