## nrpe check_swap recipe

class nrpe::checks::check_swap {

    if ($::ec2_instance_type == 't1.micro')
    or ($::ec2_instance_type == 'm1.medium')
    or ($::ec2_instance_type == 'm1.large')
    or ($::ec2_instance_type == 'c1.xlarge')
    or ($::ec2_instance_type == 'm1.xlarge')
    or ($::ec2_instance_type == 'm2.4xlarge')
    or ($::ec2_instance_type == 'm3.2xlarge') {

        # check_swap exclusion
        file { 'check_swap.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_swap.cfg',
        }
    }
    else {
        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_swap.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_swap.cfg',
        }

        file_line { 'check_swap':
            ensure  => present,
            path    => '/etc/nrpe.d/check_swap.cfg',
            line    => "command[check_swap]=${nrpe_plugins_filepath}check_swap -w 20 -c 10",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_swap.cfg'],
        }

        @@nagios_service { "check_swap_${fqdn}":
                use                   => 'generic-service,graphed-service',
                service_description   => 'check_nrpe check_swap',
                check_command         => 'check_nrpe!check_swap',
                normal_check_interval => '3',
                servicegroups         => 'check_swap',
                host_name             => $::fqdn,
                contact_groups        => $::group,
                register              => '1',
        }
    }
}
