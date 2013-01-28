name "log-base"
description "Base box"
run_list(
    "recipe[elasticsearch]",
    "recipe[logstash::server]",
    #"recipe[logstash::kibana]",
)

# TODO: Configuration of the patterns
override_attributes(
  'elasticsearch' => { 'cluster' => { 'name' => 'logstash' } },
  'logstash' => {
    'server' => {
      'enable_embedded_es' => false,
      'install_rabbitmq' => false,
    },
    'index_cleaner' => { 'days_to_keep' => 7 },
  },
)
