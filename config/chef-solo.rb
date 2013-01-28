chef_root = File.expand_path('..', __FILE__)

log_level :info
cookbook_path %w(cookbooks ../vendor/cookbooks).map{|path| File.join chef_root, path }
role_path File.join(chef_root, 'roles')
