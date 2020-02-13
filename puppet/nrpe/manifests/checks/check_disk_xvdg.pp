## nrpe check_disk_xvdg recipe

class nrpe::checks::check_disk_xvdg {

    if ($::server_type == 'cassandra')
        or ($::server_type == 'cassops') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_disk_xvdg.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_disk_xvdg.cfg',
        }

        file_line { 'check_disk_xvdg':
            ensure  => present,
            path    => '/etc/nrpe.d/check_disk_xvdg.cfg',
            line    => "command[check_disk_xvdg]=${nrpe_plugins_filepath}check_disk -W 20% -K 10% -w 20% -c 10% -p /dev/xvdg",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_disk_xvdg.cfg'],
        }

        @@nagios_service { "check_disk_xvdg_${fqdn}":
            use                   => 'generic-service,graphed-service',
            service_description   => 'check_nrpe check_disk_xvdg',
            check_command         => 'check_nrpe!check_disk_xvdg',
            normal_check_interval => '3',
            servicegroups         => 'check_disk',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_disk_xvdg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_disk_xvdg.cfg',
        }
    }

}
