include_recipe 'base'
include_recipe 'java'

include_recipe 'elasticsearch::data'
include_recipe 'elasticsearch'
include_recipe 'elasticsearch::aws' if node['ec2']

install_plugin 'royrusso/elasticsearch-HQ'
