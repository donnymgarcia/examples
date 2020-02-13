## nrpe check_procs_tomcat-broker recipe

class nrpe::checks::check_procs_tomcat-broker {

    if ($::server_type == 'wowzamilb') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_tomcat-broker.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_tomcat-broker.cfg',
        }

        file_line { 'check_procs_tomcat-broker':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_tomcat-broker.cfg',
            line    => "command[check_procs_tomcat-broker]=${nrpe_plugins_filepath}check_procs -c 2: -a \"jsvc.exec -java-home /usr/lib/jvm/jre -user broker -pidfile /opt/apache-tomcat-7.0.35/.apache-tomcat-broker-endpoint.pid -wait 10 -outfile /opt/apache-tomcat-7.0.35/logs/catalina-daemon.out -errfile &1 -classpath /opt/apache-tomcat-7.0.35/bin/bootstrap.jar:/opt/apache-tomcat-7.0.35/bin/commons-daemon.jar:/opt/apache-tomcat-7.0.35/bin/tomcat-juli.jar -Djava.util.logging.config.file=/opt/apache-tomcat-7.0.35/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.endorsed.dirs=/opt/apache-tomcat-7.0.35/endorsed -Dcatalina.base=/opt/apache-tomcat-7.0.35 -Dcatalina.home=/opt/apache-tomcat-7.0.35 -Djava.io.tmpdir=/opt/apache-tomcat-7.0.35/temp org.apache.catalina.startup.Bootstrap\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_tomcat-broker.cfg'],
        }

        @@nagios_service { "check_procs_tomcat-broker_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_tomcat-broker',
            check_command         => 'check_nrpe!check_procs_tomcat-broker',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_tomcat-broker.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_tomcat-broker.cfg',
        }
    }
}
