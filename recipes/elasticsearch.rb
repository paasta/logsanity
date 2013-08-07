include_recipe 'base'
include_recipe 'java'

include_recipe 'elasticsearch::data'
include_recipe 'elasticsearch'
include_recipe 'elasticsearch::aws' if node['ec2']

install_plugin 'royrusso/elasticsearch-HQ'
install_plugin 'lukas-vlcek/bigdesk/2.2.1'

# Setup the logstash index cleaner

template "/etc/cron.daily/logstash-index-cleanup" do
  source "logstash-crontab.erb"
  mode '0755'
end
