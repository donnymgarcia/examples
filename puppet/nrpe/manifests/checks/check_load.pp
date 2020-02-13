## nrpe check_load recipe

class nrpe::checks::check_load {

    @@nagios_service { "check_load_${fqdn}":
            use                   => 'generic-service,graphed-service',
            service_description   => 'check_nrpe check_load',
            check_command         => 'check_nrpe!check_load',
            normal_check_interval => '3',
            servicegroups         => 'check_load',
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

    file { 'check_load.cfg':
        ensure => present,
        path   => '/etc/nrpe.d/check_load.cfg',
    }

    if ( $::server_type == 'cassandra')
    or ( $::server_type == 'cassops') {

        ## cassandra threshold
        file_line { 'check_load':
            ensure  => present,
            path    => '/etc/nrpe.d/check_load.cfg',
            line    => "command[check_load]=${nrpe_plugins_filepath}check_load -w 20,15,10 -c 35,30,25",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_load.cfg'],
        }
    }
    elsif ( $::server_type == 'graylog') {

        ## graylog threshold
        file_line { 'check_load':
            ensure  => present,
            path    => '/etc/nrpe.d/check_load.cfg',
            line    => "command[check_load]=${nrpe_plugins_filepath}check_load -w 20,15,10 -c 35,30,25",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_load.cfg'],
        }
    }
    else {

        file_line { 'check_load':
            ensure  => present,
            path    => '/etc/nrpe.d/check_load.cfg',
            line    => "command[check_load]=${nrpe_plugins_filepath}check_load -w 15,10,5 -c 30,25,20",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_load.cfg'],
        }
    }

}
