## nrpe check_procs_opscenter recipe

class nrpe::checks::check_procs_opscenter {

    if ($::server_type == 'cassandra') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_opscenter.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_opscenter.cfg',
        }

        file_line { 'check_procs_opscenter':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_opscenter.cfg',
            line    => "command[check_procs_opscenter]=${nrpe_plugins_filepath}check_procs -c 1: -a \"-Dagent-pidfile=./opscenter-agent.pid -Dlog4j.configuration=./conf/log4j.properties -jar opscenter-agent-\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_opscenter.cfg'],
        }

        @@nagios_service { "check_procs_opscenter_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_opscenter',
            check_command         => 'check_nrpe!check_procs_opscenter',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_opscenter.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_opscenter.cfg',
        }
    }
}
