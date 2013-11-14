include_attribute 'base::hostname'

set['elasticsearch']['cluster']['name'] = 'logsanity'
set['elasticsearch']['node']['name'] = node['base']['hostname']
set['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false if node['ec2']
