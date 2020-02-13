#!/usr/bin/ruby 
#
# Name:: check_juniper_bandwidth.rb
# Description:: check for juniper interface bandwidth util
#

require 'rubygems'
require 'optparse'

juniper_ifDescr_oid="iso.3.6.1.2.1.2.2.1.2"
juniper_ifInOctets_oid=".1.3.6.1.2.1.31.1.1.1.6" ## COUNTER64
juniper_ifOutOctets_oid=".1.3.6.1.2.1.31.1.1.1.10" ## COUNTER64
juniper_ifSpeed_oid="iso.3.6.1.2.1.2.2.1.5"
juniper_uptime_oid="iso.3.6.1.2.1.1.3.0"

## options
options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: check_juniper_bandwidth.rb -H HOSTADDRESS -C COMMUNITY -i INTERFACE_OID -w WARN -c CRIT"

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

  options[:interface_oid] = nil
  opts.on( '-d', '--interfaceOID INTERFACE_OID', 'Interface OID' ) do |interface_oid|
    options[:interface_oid] = interface_oid
  end

  options[:warnIn] = nil
  opts.on( '-i', '--warnIn WARNING', 'InOctet Warning threshold' ) do |warn_in|
    options[:warnIn] = warn_in
  end

  options[:critIn] = nil
  opts.on( '-I', '--critIn CRITICAL', 'In Octet Critical threshold' ) do |crit_in|
    options[:critIn] = crit_in
  end

  options[:warnOut] = nil
  opts.on( '-o', '--warnOut WARNING', 'Out Warning threshold' ) do |warn_out|
    options[:warnOut] = warn_out
  end

  options[:critOut] = nil
  opts.on( '-O', '--critOut CRITICAL', 'Critical threshold' ) do |crit_out|
    options[:critOut] = crit_out
  end
  
  options[:interval] = nil
  opts.on( '-t', '--interval INTERVAL', 'Interval' ) do |interval|
    options[:interval] = interval
  end

  options[:walk] = nil
  opts.on( '-k', '--walk TRUE', 'Snmpwalk ifDescr' ) do |walk|
    options[:walk] = walk
  end
end

ARGV.push('-h') if ARGV.empty?

optparse.parse!

## start output print
print "JUNIPER INTERFACE BANDWIDTH UTILIZATION: "

## response check
system("snmpget -v2c -c#{options[:community]} #{options[:hostaddress]} #{juniper_uptime_oid} >> /dev/null 2>&1")
if $?.exitstatus != 0
  puts " CRIT - snmp query error"
  exit 2
end

## walk
if "#{options[:walk]}".upcase == "TRUE"
  ifDescr_walk=`snmpwalk -v2c -c#{options[:community]} #{options[:hostaddress]} #{juniper_ifDescr_oid} | awk -F"#{juniper_ifDescr_oid}." '{print $2}' | sed s/STRING:\\ //g`
  puts " --walk == TRUE"
  puts ifDescr_walk
  exit 0
end

## query/eval
ifSpeed_result=String.new
ifInOctets_result=String.new
ifOutOctets_result=String.new
util_in=String.new.to_f
util_out=String.new.to_f
percent_in=String.new
percent_out=String.new
result_in=String.new
result_out=String.new
perf_result=String.new
seconds_delta="#{options[:interval]}".to_i

EXIT_CRIT=false
EXIT_WARN=false
EXIT_OK=false

ifDescr=`snmpget -v2c -c#{options[:community]} #{options[:hostaddress]} #{juniper_ifDescr_oid}.#{options[:interface_oid]} | awk -F: '{print $2}'`.strip
ifSpeed=`snmpget -v2c -c#{options[:community]} #{options[:hostaddress]} #{juniper_ifSpeed_oid}.#{options[:interface_oid]} | awk -F: '{print $2}'`.to_i
ifInOctets_first=`snmpget -v2c -c#{options[:community]} #{options[:hostaddress]} #{juniper_ifInOctets_oid}.#{options[:interface_oid]} | awk -F: '{print $2}'`.to_i
ifOutOctets_first=`snmpget -v2c -c#{options[:community]} #{options[:hostaddress]} #{juniper_ifOutOctets_oid}.#{options[:interface_oid]} | awk -F: '{print $2}'`.to_i
sleep (seconds_delta)
ifInOctets_last=`snmpget -v2c -c#{options[:community]} #{options[:hostaddress]} #{juniper_ifInOctets_oid}.#{options[:interface_oid]} | awk -F: '{print $2}'`.to_i
ifOutOctets_last=`snmpget -v2c -c#{options[:community]} #{options[:hostaddress]} #{juniper_ifOutOctets_oid}.#{options[:interface_oid]} | awk -F: '{print $2}'`.to_i

## bandwidth util calc
ifInOctets_delta=ifInOctets_last - ifInOctets_first
ifOutOctets_delta=ifOutOctets_last - ifOutOctets_first

numerator_in=ifInOctets_delta * 8 * 100
numerator_out=ifOutOctets_delta * 8 * 100
denominator=seconds_delta * ifSpeed

util_in=numerator_in.to_f / denominator.to_f
util_out=numerator_out.to_f / denominator.to_f

percent_in=(util_in).round()
percent_out=(util_out).round()

result_in << " In: (" + percent_in.to_s + ")% "
result_out << " Out: (" + percent_out.to_s + ")%"

perf_result <<  "interface_bandwidth_util_percent_in=" + percent_in.to_s
perf_result <<  " interface_bandwidth_util_percent_out=" + percent_out.to_s

if percent_in >= "#{options[:critIn]}".to_i
  status = 2
  $EXIT_CRIT=true
  STATE_IN="CRIT"
elsif percent_in >= "#{options[:warnIn]}".to_i
  status = 1
  $EXIT_WARN=true
  STATE_IN="WARN"
else
  $EXIT_OK=true
  status = 0
  STATE_IN="OK"
end

if percent_out >= "#{options[:critOut]}".to_i
  status = 2
  $EXIT_CRIT=true
  STATE_OUT="CRIT"
elsif percent_out >= "#{options[:warnOut]}".to_i
  status = 1
  $EXIT_WARN=true
  STATE_OUT="WARN"
else
  $EXIT_OK=true
  status = 0
  STATE_OUT="OK"
end

puts ifDescr + " " + STATE_IN + " -" + result_in + STATE_OUT + " -" + result_out + " | " + perf_result

## exit
if $EXIT_CRIT == true
  exit status
elsif $EXIT_WARN == true
  exit status
end

if $EXIT_OK == true
  exit status
else
  ## unknown
  exit 3
end