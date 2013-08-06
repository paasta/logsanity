include_recipe 'base'
include_recipe 'ark'
include_recipe 'java'

logstash_jar = File.join(
  node['logstash']['base_dir'],
  Digest::MD5.hexdigest(node['logstash']['package_url']),
  File.basename(node['logstash']['package_url'])
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
  File.dirname(logstash_jar)
].each do |dir|
  directory dir do
    mode '0755'
    recursive true
  end
end

directory node['logstash']['log_dir'] do
  owner node['logstash']['user']
  group node['logstash']['group']
  mode '0755'
  recursive true
end

remote_file logstash_jar do
  source node['logstash']['package_url']
  mode '0644'
  action :create_if_missing
end

ark "cloud-aws-plugin" do
  version           node['logstash']['cloud-aws-plugin']['version']
  url               node['logstash']['cloud-aws-plugin']['download_url']
  prefix_home       node['logstash']['base_dir']
  strip_leading_dir false
  action            :install
end

template "#{node['logstash']['config_dir']}/elasticsearch.yml" do
  source    "logstash-elasticsearch.yml.erb"
  mode      0644
end

node['logstash']['patterns'].each_pair do |key, patterns|
  data = patterns.sort.collect {|name, pattern| "#{name} #{pattern}" }.join("\n")
  file "#{node['logstash']['pattern_dir']}/#{key}" do
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

  # Remove a logstash config by using an empty config
  if config.empty?

    file "#{node['logstash']['config_dir']}/#{key}.conf" do
      action :delete
      notifies :stop, "service[#{service_name}]"
    end

    file "/etc/init/#{service_name}.conf" do
      action :delete
    end

  else

    template "#{node['logstash']['config_dir']}/#{key}.conf" do
      source 'logstash-agent.conf.erb'
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
end
