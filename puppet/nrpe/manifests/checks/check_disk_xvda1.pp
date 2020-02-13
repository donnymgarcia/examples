## nrpe check_disk_xvda1 recipe

class nrpe::checks::check_disk_xvda1 {

    ## nrpe.erb nrpe plugins filepath
    case $::operatingsystem {
        'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
        'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
    }

    file { 'check_disk_xvda1.cfg':
        ensure => present,
        path   => '/etc/nrpe.d/check_disk_xvda1.cfg',
    }

    file_line { 'check_disk_xvda1':
        ensure  => present,
        path    => '/etc/nrpe.d/check_disk_xvda1.cfg',
        line    => "command[check_disk_xvda1]=${nrpe_plugins_filepath}check_disk -W 20% -K 10% -w 20% -c 10% -p /dev/xvda1",
        notify  => Service['nrpe'],
        require => File['nrpe.d', 'check_disk_xvda1.cfg'],
    }

    @@nagios_service { "check_disk_xvda1_${fqdn}":
            use                   => 'generic-service,graphed-service',
            service_description   => 'check_nrpe check_disk_xvda1',
            check_command         => 'check_nrpe!check_disk_xvda1',
            normal_check_interval => '3',
            servicegroups         => 'check_disk',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
    }

}
