## nrpe check_procs_syslog-ng recipe

class nrpe::checks::check_procs_syslog-ng {

    if ($::server_type == 'syslog') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_syslog-ng.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_syslog-ng.cfg',
        }

        file_line { 'check_procs_syslog-ng':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_syslog-ng.cfg',
            line    => "command[check_procs_syslog-ng]=${nrpe_plugins_filepath}check_procs -c 1: -a \"syslog-ng -p /var/run/syslog-ng.pid\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_syslog-ng.cfg'],
        }

        @@nagios_service { "check_procs_syslog-ng_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_syslog-ng',
            check_command         => 'check_nrpe!check_procs_syslog-ng',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_syslog-ng.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_syslog-ng.cfg',
        }
    }
}
