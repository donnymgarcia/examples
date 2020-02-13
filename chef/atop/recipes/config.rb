#
# Cookbook Name:: atop
# Recipe:: config.rb
#
#

## atop granular peak 7AM
cron 'atop_granular_peak_0700' do
  minute '58'
  hour '6'
  command "/usr/bin/atop -a -w /var/log/atop.`hostname`.`date +\\%m\\%d\\%Y`.0700.log 30 32"
end

## atop granular peak 8AM
cron 'atop_granular_peak_0800' do
  minute '58'
  hour '7'
  command "/usr/bin/atop -a -w /var/log/atop.`hostname`.`date +\\%m\\%d\\%Y`.0800.log 30 32"
end

## atop granular peak 9AM
cron 'atop_granular_peak_0900' do
  minute '58'
  hour '8'
  command "/usr/bin/atop -a -w /var/log/atop.`hostname`.`date +\\%m\\%d\\%Y`.0900.log 30 32"
end

## cron atop log removal older than 45 days
cron 'rm_atop_logs_45_days' do
  minute '0'
  hour '1'
  weekday '6'
  command "echo \"## WEEKLY ATOP LOGS PURGE: `date` ##\" >> /var/log/rm_atop_logs.log && find /var/log/ -name atop.`hostname`.\\* -mtime +45 -exec rm -rf {} \\; 2>&1 >> /var/log/rm_atop_logs.log"
end

template '/etc/logrotate.d/atop' do
  source 'logrotate_atop.erb'
  owner 'root'
  group 'root'
  mode 0644
end

cookbook_file '/etc/crontab' do
  source 'crontab'
  owner 'root'
  group 'root'
  mode 0644
end