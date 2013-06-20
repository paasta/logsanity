include_recipe 'logstash::server'
include_recipe 'logstash::index_cleaner'

template_path = "#{node['logstash']['base_dir']}/logstash-template.json"

template template_path do
  mode "0644"
end

execute "install-logstash-template" do
  command "curl -XPUT 'http://localhost:9200/_template/logstash/' -d @#{template_path}"
end
