include_recipe 'base'
include_recipe 'nginx'

package 'git'

directory node['kibana']['base_dir'] do
  mode '0755'
  recursive true
end

git node['kibana']['base_dir'] do
  repository node['kibana']['git']['url']
  reference node['kibana']['git']['reference']
  action :checkout
end

template File.join(node['kibana']['base_dir'], 'config.js') do
  source 'kibana-config.js.erb'
  mode '0644'
end

file '/etc/nginx/conf.d/kibana.htpasswd' do
  mode '0644'
  content node['kibana']['htpasswd']
end

template '/etc/nginx/sites-available/kibana.conf' do
  mode '0644'
end

nginx_site 'kibana.conf'
