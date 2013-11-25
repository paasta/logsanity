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

template node['kibana']['base_dir'] + '/src/config.js' do
  source 'kibana-config.js.erb'
  mode '0644'
end

template node['kibana']['base_dir'] + '/src/app/dashboards/default.json' do
  source 'kibana-default-dashboard.json.erb'
  mode '0644'
end

file '/etc/nginx/conf.d/kibana.htpasswd' do
  mode '0644'
  content node['kibana']['htpasswd']
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

nginx_site 'kibana.conf'
