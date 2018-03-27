set :stage, :production
set :rails_env, :production
set :deploy_to, '/home/deploy/apis/social_network_api'
# set :branch, 'master'
# set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# set :whenever_roles, %w{web app db}
server 'castsapp.com', user: 'deploy', roles: %w[web app db]
