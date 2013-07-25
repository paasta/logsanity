include_recipe 'base'
include_recipe 'java'

logstash_jar = File.join(
  node['logstash']['base_dir'],
  Digest::MD5.hexdigest(node['logstash']['package_url']),
  File.basename(node['logstash']['package_url'])
)

template_path = File.join(
  node['logstash']['config_dir'],
  "logstash-template.json"
)

group node['logstash']['group']
user node['logstash']['user'] do
  comment 'logstash'
  gid node['logstash']['group']
  home node['logstash']['base_dir']
  shell '/bin/bash'
  system true
end

[
  node['logstash']['base_dir'],
  node['logstash']['config_dir'],
  node['logstash']['pattern_dir'],
  node['logstash']['log_dir']
].each do |dir|
  directory dir do
    owner node['logstash']['user']
    group node['logstash']['group']
    mode '0755'
    recursive true
  end
end

template "/etc/cron.daily/logstash-index-cleanup" do
  source "logstash-crontab.erb"
  mode '0755'
end

directory File.dirname(logstash_jar) do
  owner node['logstash']['user']
  group node['logstash']['group']
  mode '0755'
end

remote_file logstash_jar do
  source node['logstash']['package_url']
  owner node['logstash']['user']
  group node['logstash']['group']
  mode '0644'
  action :create_if_missing
end

node['logstash']['patterns'].each_pair do |key, patterns|
  data = patterns.sort.collect {|name, pattern| "#{name} #{pattern}" }.join("\n")
  file "#{node['logstash']['pattern_dir']}/#{key}" do
    owner node['logstash']['user']
    group node['logstash']['group']
    mode '0644'
    content data
  end
end

node['logstash']['config'].each_pair do |key, config|
  raise "config['inputs'] must be specified for #{key}" unless config['inputs']
  service_name = "logstash-#{key}"

  service service_name do
    provider Chef::Provider::Service::Upstart
    supports status: true, start: true, stop: true, restart: true
    action :nothing
  end

  template "#{node['logstash']['config_dir']}/#{key}.conf" do
    source 'logstash-agent.conf.erb'
    owner node['logstash']['user']
    group node['logstash']['group']
    mode '0644'
    variables(
      config: config
    )
    notifies :restart, "service[#{service_name}]"
  end

  template "/etc/init/#{service_name}.conf" do
    source 'logstash-upstart.conf.erb'
    mode '0644'
    variables(
      logstash_jar: logstash_jar,
      name: key,
    )
    notifies :restart, "service[#{service_name}]"
  end
end

# Setup the ES index template

template template_path do
  mode "0644"
end

# FIXME: Might not work on the first run
execute "install-logstash-template" do
  command "curl -XPUT 'http://#{node['logstash']['elasticsearch_ip']}:9200/_template/logstash/' -d @#{template_path}"
  retries 6
  retry_delay 10
end

