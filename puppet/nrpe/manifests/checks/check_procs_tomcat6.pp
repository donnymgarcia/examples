## nrpe check_procs_tomcat6 recipe

class nrpe::checks::check_procs_tomcat6 {

    if ($::server_type == 'pushtomcat') or ($::server_type == 'socialtomcat') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_tomcat6.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_tomcat6.cfg',
        }

        file_line { 'check_procs_tomcat6':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_tomcat6.cfg',
            line    => "command[check_procs_tomcat6]=${nrpe_plugins_filepath}check_procs -c 1: -a \"-classpath :/usr/share/tomcat6/bin/bootstrap.jar:/usr/share/tomcat6/bin/tomcat-juli.jar:/usr/share/java/commons-daemon.jar -Dcatalina.base=/usr/share/tomcat6 -Dcatalina.home=/usr/share/tomcat6\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_tomcat6.cfg'],
        }

        @@nagios_service { "check_procs_tomcat6_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_tomcat6',
            check_command         => 'check_nrpe!check_procs_tomcat6',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_tomcat6.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_tomcat6.cfg',
        }
    }
}
