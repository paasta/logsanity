default['kibana']['base_dir'] = '/opt/kibana'
default['kibana']['git_url'] = 'https://github.com/paasta/kibana.git'
default['kibana']['git_ref'] = 'logsanity'
# http://wiki.nginx.org/Faq#How_do_I_generate_an_.htpasswd_file_without_having_Apache_tools_installed.3F
# printf "admin:$(openssl passwd -apr1 admin)\n"
default['kibana']['htpasswd'] = <<HTPASSWD
admin:$apr1$Rm275vmP$VYpcezUUYN9SYZAgw8VZt0
HTPASSWD

# Contains the .crt file data
default['kibana']['ssl_crt'] = nil
# Contains the .key file data - with no password
default['kibana']['ssl_key'] = nil

set['nginx']['default_site_enabled'] = false
