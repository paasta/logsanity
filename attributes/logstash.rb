set['logstash']['index_cleaner']['days_to_keep'] = 7
set['logstash']['server']['install_rabbitmq']    = false
set['logstash']['server']['enable_embedded_es']  = false
set['logstash']['elasticsearch_ip'] = '127.0.0.1'
set['logstash']['elasticsearch_cluster'] = node['elasticsearch']['cluster']['name']
set['logstash']['server']['inputs'] = []
set['logstash']['server']['filters'] = []
