set[:elasticsearch][:version]                 = '0.90.1'
set[:elasticsearch][:cluster][:name]          = 'elasticsearch'
set[:logstash][:index_cleaner][:days_to_keep] = 7
set[:logstash][:server][:install_rabbitmq]    = false
set[:logstash][:server][:enable_embedded_es]  = false

set[:logstash][:server][:outputs] = [{
  elasticsearch: {
    embedded: false,
    cluster: "logstash",
    host: "localhost",
  }
}]
