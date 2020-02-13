#
# Cookbook Name:: atop
# Recipe:: config-s3cmd.rb
#
#

cookbook_file '/root/.s3cfg' do
  source 's3cfg'
  owner 'root'
  group 'root'
  mode 0755
end

## clean up old s3cmd install
file '/usr/local/bin/s3cmd' do
  action :delete
end

## delete default atop logrotation
file '/etc/logrotate.d/atop' do
  action :delete
end

template '/etc/init.d/atop' do
  source 'atop.erb'
  owner 'root'
  group 'root'
  mode 0755
end

## kill atop started by install
execute 'atop_kill' do
  command "ps -ef | grep '/usr/bin/atop -a -w /var/log/atop.log 600' | grep -v grep | awk '{print $2}' | xargs kill -9"
  only_if "ps -ef | grep '/usr/bin/atop -a -w /var/log/atop.log 600' | grep -v grep"
end
  
## cron for atop s3 sync
cron 'atop_cron_sync' do
  minute '*/5'
  command "date >> /var/log/s3cmd_atop.log && /usr/bin/s3cmd put /var/log/atop.`hostname`.`date +\\%m\\%d\\%Y`.log s3://bjn-app-logs 2>&1 >> /var/log/s3cmd_atop.log"
end

## cron for atop last sync
cron 'atop_cron_last_sync' do
  minute '1'
  hour '0'
  command "date >> /var/log/s3cmd_atop.log && /usr/bin/s3cmd put /var/log/atop.`hostname`.* s3://bjn-app-logs 2>&1 >> /var/log/s3cmd_atop.log"
end

## atop background command
cron 'atop_run' do
  minute '0'
  hour '0'
  command "nohup /usr/bin/atop -S -a -w /var/log/atop.`hostname`.`date +\\%m\\%d\\%Y`.log #{node[:atop][:interval]} &"
end

## cron atop log removal older than 45 days
cron 'rm_atop_logs_45_days' do
  minute '0'
  hour '1'
  weekday '6'
  command "echo \"## WEEKLY ATOP LOGS PURGE: `date` ##\" >> /var/log/rm_atop_logs.log && find /var/log/ -name atop.`hostname`.\\* -mtime +45 -exec rm -rf {} \\; 2>&1 >> /var/log/rm_atop_logs.log"
end