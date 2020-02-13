## nrpe check_procs_cassandra recipe

class nrpe::checks::check_procs_cassandra {

    if ($::server_type == 'cassandra') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_cassandra.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_cassandra.cfg',
        }

        file_line { 'check_procs_cassandra':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_cassandra.cfg',
            line    => "command[check_procs_cassandra]=${nrpe_plugins_filepath}check_procs -c 1: -a \"/usr/java/latest/bin/java -ea -javaagent:/opt/cassandra/bin/../lib/jamm-\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_cassandra.cfg'],
        }

        @@nagios_service { "check_procs_cassandra_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_cassandra',
            check_command         => 'check_nrpe!check_procs_cassandra',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_cassandra.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_cassandra.cfg',
        }
    }
}
