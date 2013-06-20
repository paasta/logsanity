include_recipe 'machine-base'

include_recipe 'log-service::elasticsearch'
include_recipe 'log-service::logstash'
include_recipe 'log-service::kibana'
