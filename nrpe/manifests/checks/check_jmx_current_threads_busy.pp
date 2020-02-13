## nrpe check_jmx_current_threads_busy recipe

class nrpe::checks::check_jmx_current_threads_busy {

    if ($::env == 'dev')
    or ($::env == 'qa') {

        if ($::server_type == 'pushtomcat') {

            ## nrpe.erb nrpe plugins filepath
            case $::operatingsystem {
                'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
                'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
                default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            }

            ## check_jmx
            file { "${nrpe_plugins_filepath}check_jmx":
                owner   => root,
                group   => root,
                mode    => '0755',
                source  => 'puppet:///modules/nrpe/check_jmx',
            }

            ## jmxquery.jar
            file { "${nrpe_plugins_filepath}jmxquery.jar":
                owner   => root,
                group   => root,
                mode    => '0755',
                source  => 'puppet:///modules/nrpe/jmxquery.jar',
            }

            file { 'check_jmx_currentThreadsBusy.cfg':
                ensure => present,
                path   => '/etc/nrpe.d/check_jmx_currentThreadsBusy.cfg',
            }

            file_line { 'check_jmx_currentThreadsBusy':
                ensure  => present,
                path    => '/etc/nrpe.d/check_jmx_currentThreadsBusy.cfg',
                line    => "command[check_jmx_currentThreadsBusy]=${nrpe_plugins_filepath}check_jmx -U service:jmx:rmi:///jndi/rmi://${ipaddress}:9999/jmxrmi -O Catalina:type=ThreadPool,name=http-8112 -A currentThreadsBusy -w 150 -c 180",
                notify  => Service['nrpe'],
                require => File['nrpe.d', 'check_jmx_currentThreadsBusy.cfg'],
            }

            @@nagios_service { "check_jmx_currentThreadsBusy_${fqdn}":
                    use                   => 'generic-service,graphed-service',
                    service_description   => 'check_nrpe check_jmx_currentThreadsBusy',
                    check_command         => 'check_nrpe!check_jmx_currentThreadsBusy',
                    normal_check_interval => '3',
                    servicegroups         => 'check_jmx',
                    host_name             => $::fqdn,
                    contact_groups        => $::group,
                    register              => '1',
            }

        }
        else {
            # check_jmx_currentThreadsBusy exclusion
            file { 'check_jmx_currentThreadsBusy.cfg':
                ensure => absent,
                path   => '/etc/nrpe.d/check_jmx_currentThreadsBusy.cfg',
            }

        }
    }
}