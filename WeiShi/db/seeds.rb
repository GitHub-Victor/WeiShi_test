# -*- encoding : utf-8 -*-
require 'rubygems'
require 'factory_girl_rails'

# 添加默认用户
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end
puts '*---------------------'
puts 'DEFAULT ADMIN USERS'
user = User.find_or_create_by_username :username => ENV['ADMIN_USERNAME'].dup, :nickname => ENV['ADMIN_NICKNAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'admin: ' << ENV['ADMIN_USERNAME'].dup
puts 'password: ' << ENV['ADMIN_PASSWORD'].dup
user.add_role :superadmin