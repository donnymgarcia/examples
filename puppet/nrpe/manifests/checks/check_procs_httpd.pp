## nrpe check_procs_httpd recipe

class nrpe::checks::check_procs_httpd {

    if ($::server_type == 'wowzamilb') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_httpd.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_httpd.cfg',
        }

        file_line { 'check_procs_httpd':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_httpd.cfg',
            line    => "command[check_procs_httpd]=${nrpe_plugins_filepath}check_procs -c 1: -a \"/usr/sbin/httpd\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_httpd.cfg'],
        }

        @@nagios_service { "check_procs_httpd_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_httpd',
            check_command         => 'check_nrpe!check_procs_httpd',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_httpd.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_httpd.cfg',
        }
    }
}
