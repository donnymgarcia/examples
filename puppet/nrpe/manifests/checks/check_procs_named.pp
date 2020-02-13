## nrpe check_procs_named recipe

class nrpe::checks::check_procs_named {

    if ($::server_type == 'master_dns') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_named.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_named.cfg',
        }

        file_line { 'check_procs_named':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_named.cfg',
            line    => "command[check_procs_named]=${nrpe_plugins_filepath}check_procs -c 1: -a \"/usr/sbin/named -u named\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_named.cfg'],
        }

        @@nagios_service { "check_procs_named_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_named',
            check_command         => 'check_nrpe!check_procs_named',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_named.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_named.cfg',
        }
    }
}
