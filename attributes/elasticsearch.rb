include_attribute 'base::hostname'

set['elasticsearch']['cluster']['name'] = 'logsanity'
set['elasticsearch']['node']['name']    = node['base']['hostname']
set['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false if node['ec2']
set['elasticsearch']['plugins']['elasticsearch/elasticsearch-cloud-aws']['version'] = '1.16.0'
set['elasticsearch']['version']         = "0.90.9"
set['elasticsearch']['filename']        = "elasticsearch-#{node.elasticsearch[:version]}.tar.gz"
set['elasticsearch']['download_url']    = [node.elasticsearch[:host], node.elasticsearch[:repository], node.elasticsearch[:filename]].join('/')
