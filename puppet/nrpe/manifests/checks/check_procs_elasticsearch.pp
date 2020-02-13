## nrpe check_procs_elasticsearch recipe

class nrpe::checks::check_procs_elasticsearch {

    if ($::server_type == 'hbsearch') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_elasticsearch.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_elasticsearch.cfg',
        }

        file_line { 'check_procs_elasticsearch':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_elasticsearch.cfg',
            line    => "command[check_procs_elasticsearch]=${nrpe_plugins_filepath}check_procs -c 1: -a \"/opt/elasticsearch/bin/service/exec/elasticsearch-linux-x86-64 /opt/elasticsearch/bin/service/elasticsearch.conf wrapper.syslog.ident=elasticsearch\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_elasticsearch.cfg'],
        }

        @@nagios_service { "check_procs_elasticsearch${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_elasticsearch',
            check_command         => 'check_nrpe!check_procs_elasticsearch',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_elasticsearch.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_elasticsearch.cfg',
        }
    }
}
