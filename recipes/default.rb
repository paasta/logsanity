include_recipe 'machine-base'

include_recipe 'elasticsearch'
if node[:ec2]
  include_recipe 'elasticsearch::aws'
end

include_recipe 'logstash::server'
include_recipe 'logstash::index_cleaner'
