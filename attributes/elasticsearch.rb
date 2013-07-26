include_attribute 'base::default'

set['elasticsearch']['cluster']['name'] = 'logsanity'
set['elasticsearch']['node']['name'] = node['base']['hostname']
