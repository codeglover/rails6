set :deploy_to, '/home/ubuntu/www/rails6'
set :stage, :production
set :rails_env, :production
set :branch, "master"
set :template_dir, '/home/ubuntu/www/rails6/shared/config'
set :user, "ubuntu"

server "13.59.247.115", user: "ubuntu", roles: %w{web app db}, primary: true
#server "landlady.me", user: "travis", roles: %w{web app db}, primary: true
set :passenger_restart_with_touch, true

# set :bundle_env_variables, { "http_proxy" => "http://192.168.49.1:8000", "HTTP_PROXY" => "http://192.168.49.1:8000" }
proxy = "/usr/local/bin/corkscrew 192.168.49.1 8000 %h %p"
set :ssh_options, {
    keys: %w(/Users/eminencehc/.ssh/knife.pem),
    forward_agent: true,
    auth_methods: %w(publickey),
    port: 22,
    proxy: Net::SSH::Proxy::Command.new(proxy)
}
# LetsEncrypt
shared_path = "/home/travis/letsencrypt/"
set :letsencrypt_contact_email, 'easyvrmanager@gmail.com'
set :letsencrypt_dir, "#{shared_path}/config/letsencrypt"
set :letsencrypt_endpoint, 'https://acme-v01.api.letsencrypt.org/'
set :letsencrypt_private_key_path, "#{fetch(:letsencrypt_dir)}/private_key.pem"
# 'www.easyvrmanager.com easyvrmanager.com www.halfdomehideaway.com halfdomehideaway.com halfdomehideaway.easyvrmanager.com'
set :keep_releases, 5
#set :letsencrypt_authorize_domains, all_domains
#set :letsencrypt_certificate_request_domains, all_domains