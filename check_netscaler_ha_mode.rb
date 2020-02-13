#!/usr/bin/ruby 
#
# Name:: check_netscaler_ha_mode.rb
# Description:: check for netscaler ha mode
#

require 'rubygems'
require 'optparse'

netscaler_sysHighAvailabilityMode_oid="iso.3.6.1.4.1.5951.4.1.1.6.0"
netscaler_uptime_oid="iso.3.6.1.2.1.1.3.0"

## options
options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: check_netscaler_mem.rb -H HOSTADDRESS -C COMMUNITY -e STATE"

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end

  options[:hostaddress] = nil
  opts.on( '-H', '--hostaddress HOSTADDRESS', 'Host IP address' ) do |host|
    options[:hostaddress] = host
  end

  options[:community] = nil
  opts.on( '-C', '--community COMMUNITY', 'Community string' ) do |community|
    options[:community] = community
  end

  options[:state] = nil
  opts.on( '-e', '--expect STATE', 'Expected HA mode [ standalone|primary|secondary ]' ) do |state|
    options[:state] = state
  end
end

ARGV.push('-h') if ARGV.empty?

optparse.parse!

## start output print
print "NETSCALER HA MODE: "

## response check
system("snmpget -v2c -c#{options[:community]} #{options[:hostaddress]} #{netscaler_uptime_oid} >> /dev/null 2>&1")
if $?.exitstatus != 0
  puts "CRIT - snmp query error"
  exit 2
end

## query/eval
EXIT_CRIT=false
EXIT_OK=false
perf_result=String.new
result=String.new

ha_mode=`snmpget -v2c -c#{options[:community]} #{options[:hostaddress]} #{netscaler_sysHighAvailabilityMode_oid} | awk -F: '{print $2}'`.to_i

if "#{options[:state]}" == "standalone"
  ha_state=0
elsif "#{options[:state]}" == "primary"
  ha_state=1
elsif "#{options[:state]}" == "secondary"
  ha_state=2
end

if ha_state == ha_mode
  $EXIT_OK=true
  status=0
else
  $EXIT_CRIT=true
  status=2
end

if status == 0
  result << "OK - ( sysHighAvailabilityMode == #{options[:state]} )"
elsif status == 2
  result << "NOK - ( sysHighAvailabilityMode != #{options[:state]} )"
end

puts result

## exit
if $EXIT_CRIT == true
  exit status
elsif $EXIT_OK == true
  exit status
else
  #unknown
  exit 3
end