include_recipe 'base'
include_recipe 'java'

package 'ruby1.9.1-dev'

include_recipe 'elasticsearch::data'
include_recipe 'elasticsearch'
include_recipe 'elasticsearch::aws' if node['ec2']

install_plugin 'royrusso/elasticsearch-HQ'
install_plugin 'lukas-vlcek/bigdesk/2.2.2'

# Setup the logstash index cleaner

template "/etc/cron.daily/logstash-index-cleanup" do
  source "logstash-crontab.erb"
  mode '0755'
end
