#
# Cookbook Name:: atop
# Recipe:: package-s3cmd.rb
#
#

## s3cmd install
package 's3cmd' do
  action :install
  options '--force-yes'
end