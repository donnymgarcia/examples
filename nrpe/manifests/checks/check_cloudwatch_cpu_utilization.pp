## nrpe check_cloudwatch_CPUUtilization recipe

class nrpe::checks::check_cloudwatch_cpu_utilization {

    @@nagios_service { "check_cloudwatch_CPUUtilization_${fqdn}":
            use                   => 'generic-service,graphed-service',
            service_description   => 'check_nrpe check_cloudwatch_CPUUtilization',
            check_command         => 'check_nrpe!check_cloudwatch_CPUUtilization',
            normal_check_interval => '3',
            servicegroups         => 'check_cloudwatch_CPUUtilization',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
    }

    ## nrpe.erb nrpe plugins filepath
    case $::operatingsystem {
        'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
        'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
    }

    ## check_cloudwatch_status.rb
    file { "${nrpe_plugins_filepath}check_cloudwatch_status.rb":
        ensure  => present,
        owner   => root,
        group   => nagios,
        mode    => '0750',
        source  => 'puppet:///modules/nrpe/check_cloudwatch_status.rb',
    }

    file { 'check_cloudwatch_CPUUtilization.cfg':
        ensure => present,
        path   => '/etc/nrpe.d/check_cloudwatch_CPUUtilization.cfg',
    }

    ## determine region for --address flag
    case $facility {
            'am0': { $aws_region = 'us-east' }
            'am1': { $aws_region = 'us-east' }
            'am2': { $aws_region = 'us-west' }
    }

    if ( $::server_type == 'graylog') {

        ## graylog threshold
        file_line { 'check_cloudwatch_CPUUtilization':
            ensure  => present,
            path    => '/etc/nrpe.d/check_cloudwatch_CPUUtilization.cfg',
            line    => "command[check_cloudwatch_CPUUtilization]=${nrpe_plugins_filepath}check_cloudwatch_status.rb -a ${aws_region} -i ${ec2_instance_id} -f /etc/nagios/credentials/ec2_credentials.cfg -C CPUUtilization -c 100 -w 95",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_cloudwatch_CPUUtilization.cfg'],
        }
    }
    else {

        file_line { 'check_cloudwatch_CPUUtilization':
            ensure  => present,
            path    => '/etc/nrpe.d/check_cloudwatch_CPUUtilization.cfg',
            line    => "command[check_cloudwatch_CPUUtilization]=${nrpe_plugins_filepath}check_cloudwatch_status.rb -a ${aws_region} -i ${ec2_instance_id} -f /etc/nagios/credentials/ec2_credentials.cfg -C CPUUtilization -c 90 -w 75",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_cloudwatch_CPUUtilization.cfg'],
        }
    }

}
