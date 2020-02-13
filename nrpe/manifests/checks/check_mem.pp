## nrpe check_mem recipe

class nrpe::checks::check_mem {

    ## nrpe.erb nrpe plugins filepath
    case $::operatingsystem {
        'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
        'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
    }

    ## check_mem.pl
    file { "${nrpe_plugins_filepath}check_mem.pl":
        owner   => root,
        group   => root,
        mode    => '0755',
        source  => 'puppet:///modules/nrpe/check_mem.pl',
    }

    file { 'check_mem.cfg':
        ensure => present,
        path   => '/etc/nrpe.d/check_mem.cfg',
    }

    file_line { 'check_mem':
        ensure  => present,
        path    => '/etc/nrpe.d/check_mem.cfg',
        line    => "command[check_mem]=${nrpe_plugins_filepath}check_mem.pl -w 99 -c 100",
        notify  => Service['nrpe'],
        require => File['nrpe.d', 'check_mem.cfg'],
    }

    @@nagios_service { "check_mem_${fqdn}":
            use                   => 'generic-service,graphed-service',
            service_description   => 'check_nrpe check_mem',
            check_command         => 'check_nrpe!check_mem',
            normal_check_interval => '3',
            servicegroups         => 'check_mem',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
    }

}