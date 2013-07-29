chef_root = File.expand_path('../..', __FILE__)
cookbook_path %w(vendor/cookbooks).map{|path| File.expand_path path, chef_root }
