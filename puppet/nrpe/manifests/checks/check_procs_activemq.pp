## nrpe check_procs_activemq recipe

class nrpe::checks::check_procs_activemq {

    if ($::server_type == 'activemq') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_activemq.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_activemq.cfg',
        }

        file_line { 'check_procs_activemq':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_activemq.cfg',
            line    => "command[check_procs_activemq]=${nrpe_plugins_filepath}check_procs -c 1: -a \"-Dactivemq.home=/opt/activemq -Dactivemq.base=/opt/activemq -Dactivemq.conf=/opt/activemq/conf -Dactivemq.data=/opt/activemq/data -jar /opt/activemq/bin/run.jar start\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_activemq.cfg'],
        }

        @@nagios_service { "check_procs_activemq_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_activemq',
            check_command         => 'check_nrpe!check_procs_activemq',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_activemq.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_activemq.cfg',
        }
    }
}
