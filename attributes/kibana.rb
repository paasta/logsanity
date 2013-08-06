default['kibana']['base_dir'] = '/opt/kibana'
default['kibana']['git']['url'] = 'https://github.com/elasticsearch/kibana.git'
default['kibana']['git']['reference'] = 'd3b0a6a0d98edde491609d5205782809557e8382'
# http://wiki.nginx.org/Faq#How_do_I_generate_an_.htpasswd_file_without_having_Apache_tools_installed.3F
# printf "admin:$(openssl passwd -apr1 admin)\n"
default['kibana']['htpasswd'] = <<HTPASSWD
admin:$apr1$Rm275vmP$VYpcezUUYN9SYZAgw8VZt0
HTPASSWD
default['kibana']['elasticsearch_servers'] = ['127.0.0.1:9200'];

set['nginx']['default_site_enabled'] = false
