## nrpe check_disk_xvdf recipe

class nrpe::checks::check_disk_xvdf {

    if ($::server_type == 'cassandra')
    or ($::server_type == 'graylog')
    or ($::server_type == 'hbsearch')
    or ($::server_type == 'master_kibana')
    or ($::server_type == 'kibana')
    or ($::server_type == 'nagios')
    or ($::server_type == 'syslog')
    or ($::server_type == 'tsungcontroller') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_disk_xvdf.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_disk_xvdf.cfg',
        }

        file_line { 'check_disk_xvdf':
            ensure  => present,
            path    => '/etc/nrpe.d/check_disk_xvdf.cfg',
            line    => "command[check_disk_xvdf]=${nrpe_plugins_filepath}check_disk -W 20% -K 10% -w 20% -c 10% -p /dev/xvdf",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_disk_xvdf.cfg'],
        }

        @@nagios_service { "check_disk_xvdf_${fqdn}":
            use                   => 'generic-service,graphed-service',
            service_description   => 'check_nrpe check_disk_xvdf',
            check_command         => 'check_nrpe!check_disk_xvdf',
            normal_check_interval => '3',
            servicegroups         => 'check_disk',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_disk_xvdf':
            ensure => absent,
            path   => '/etc/nrpe.d/check_disk_xvdf.cfg',
        }
    }

}
