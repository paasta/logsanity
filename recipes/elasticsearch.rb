include_recipe 'base'
include_recipe 'java'

include_recipe 'elasticsearch::data'
include_recipe 'elasticsearch'
include_recipe 'elasticsearch::aws' if node['ec2']

install_plugin 'royrusso/elasticsearch-HQ'
install_plugin 'lukas-vlcek/bigdesk/2.2.1'


# Setup the logstash index template
template_path = File.join(
  node['logstash']['config_dir'],
  "logstash-template.json"
)

template template_path do
  mode "0644"
end

execute "install-logstash-template" do
  command "curl -XPUT 'http://127.0.0.1:9200/_template/logstash/' -d @#{template_path}"
  retries 6
  retry_delay 10
end

# Setup the logstash index cleaner

template "/etc/cron.daily/logstash-index-cleanup" do
  source "logstash-crontab.erb"
  mode '0755'
end
