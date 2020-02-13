## nrpe check_jmx_heap_memory_usage recipe

class nrpe::checks::check_jmx_heap_memory_usage {

    if ($::env == 'dev')
    or ($::env == 'qa') {

        if ($::server_type == 'pushtomcat') {

            ## nrpe.erb nrpe plugins filepath
            case $::operatingsystem {
                'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
                'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
                default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            }

            file { 'check_jmx_HeapMemoryUsage.cfg':
                ensure => present,
                path   => '/etc/nrpe.d/check_jmx_HeapMemoryUsage.cfg',
            }

            file_line { 'check_jmx_HeapMemoryUsage':
                ensure  => present,
                path    => '/etc/nrpe.d/check_jmx_HeapMemoryUsage.cfg',
                line    => "command[check_jmx_HeapMemoryUsage]=${nrpe_plugins_filepath}check_jmx -U service:jmx:rmi:///jndi/rmi://${ipaddress}:9999/jmxrmi  -O java.lang:type=Memory -A HeapMemoryUsage -K used -I HeapMemoryUsage -J used -vvvv -w 1825361100 -c 1932735283",
                notify  => Service['nrpe'],
                require => File['nrpe.d', 'check_jmx_HeapMemoryUsage.cfg'],
            }

            @@nagios_service { "check_jmx_HeapMemoryUsage_${fqdn}":
                    use                   => 'generic-service,graphed-service',
                    service_description   => 'check_nrpe check_jmx_HeapMemoryUsage',
                    check_command         => 'check_nrpe!check_jmx_HeapMemoryUsage',
                    normal_check_interval => '3',
                    servicegroups         => 'check_jmx',
                    host_name             => $::fqdn,
                    contact_groups        => $::group,
                    register              => '1',
            }

        }
        else {
            # check_jmx_HeapMemoryUsage exclusion
            file { 'check_jmx_HeapMemoryUsage.cfg':
                ensure => absent,
                path   => '/etc/nrpe.d/check_jmx_HeapMemoryUsage.cfg',
            }

        }
    }
}