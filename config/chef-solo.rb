chef_root = File.expand_path('..', __FILE__)

log_level :info
cookbook_path %w(../vendor/cookbooks).map{|path| File.expand_path path, chef_root }
role_path File.join(chef_root, 'roles')
