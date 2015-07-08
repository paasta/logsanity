include_recipe 'base'
include_recipe 'nginx'

package 'git'

directory node['kibana']['base_dir'] do
  mode '0755'
  recursive true
end

git node['kibana']['base_dir'] do
  repository node['kibana']['git_url']
  reference node['kibana']['git_ref']
  action :checkout
end

has_ssl = false
if node['kibana']['ssl_crt'] && node['kibana']['ssl_key']
  has_ssl = true

  %w[crt key].each do |type|
    file "/etc/ssl/private/kibana.#{type}" do
      owner "root"
      mode "0600"
      content node['kibana']['ssl_' + type]
      backup false
    end
  end
else
  %w[crt key].each do |type|
    file "/etc/ssl/private/kibana.#{type}" do
      backup false
      action :delete
    end
  end
end

template '/etc/nginx/sites-available/kibana.conf' do
  mode '0644'
  variables(
    servers: node['logsanity']['elasticsearch_servers'],
    has_ssl: has_ssl
  )
end

template '/etc/oauth2_proxy.conf' do
  mode '0600'
  variables(
    client_id: node['kibana']['oauth2_client_id'],
    client_secret: node['kibana']['oauth2_client_secret'],
    cookie_secret: node['kibana']['oauth2_cookie_secret'],
    cookie_domain: node['kibana']['oauth2_cookie_domain']
  )
end

cookbook_file '/etc/init/oauth2_proxy.conf' do
  source 'oauth2_proxy.conf'
  mode '0644'
  action :create
end

remote_file '/usr/local/bin/oauth2_proxy' do
  source 'https://s3.amazonaws.com/mediacore-public/software/oauth2_proxy-2.0.1'
  checksum '537dfc5bd71a00039c6cb09dcd170f37790d129861e4717253911d0a89bb931b'
  owner 'root'
  mode '0755'
  action :create
end

nginx_site 'kibana.conf'

