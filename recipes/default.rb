include_recipe 'machine-base'

include_recipe 'logsanity::elasticsearch'
include_recipe 'logsanity::logstash'
include_recipe 'logsanity::kibana'
