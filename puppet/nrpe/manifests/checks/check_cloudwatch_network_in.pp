## nrpe check_cloudwatch_NetworkIn recipe

class nrpe::checks::check_cloudwatch_network_in {

    ## nrpe.erb nrpe plugins filepath
    case $::operatingsystem {
        'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
        'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
    }

    ### check_cloudwatch_status.rb
#    file { "${nrpe_plugins_filepath}check_cloudwatch_status.rb":
#        ensure  => present,
#        owner   => root,
#        group   => nagios,
#        mode    => '0750',
#        source  => 'puppet:///modules/nrpe/check_cloudwatch_status.rb',
#    }

    file { 'check_cloudwatch_NetworkIn.cfg':
        ensure => present,
        path   => '/etc/nrpe.d/check_cloudwatch_NetworkIn.cfg',
    }

    ## determine region for --address flag
    case $facility {
            'am0': { $aws_region = 'us-east' }
            'am1': { $aws_region = 'us-east' }
            'am2': { $aws_region = 'us-west' }
    }

    file_line { 'check_cloudwatch_NetworkIn':
        ensure  => present,
        path    => '/etc/nrpe.d/check_cloudwatch_NetworkIn.cfg',
        line    => "command[check_cloudwatch_NetworkIn]=${nrpe_plugins_filepath}check_cloudwatch_status.rb -a ${aws_region} -i ${ec2_instance_id} -f /etc/nagios/credentials/ec2_credentials.cfg -C NetworkIn -c 150000000 -w 100000000",
        notify  => Service['nrpe'],
        require => File['nrpe.d', 'check_cloudwatch_NetworkIn.cfg'],
    }

    @@nagios_service { "check_cloudwatch_NetworkIn_${fqdn}":
            use                   => 'generic-service,graphed-service',
            service_description   => 'check_nrpe check_cloudwatch_NetworkIn',
            check_command         => 'check_nrpe!check_cloudwatch_NetworkIn',
            normal_check_interval => '3',
            servicegroups         => 'check_cloudwatch_NetworkIn',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            notifications_enabled => '0,',
            register              => '1',
    }

}