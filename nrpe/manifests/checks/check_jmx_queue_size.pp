## nrpe check_jmx_queue_size recipe

class nrpe::checks::check_jmx_queue_size {

    if ($::env == 'dev') 
    or ($::env == 'qa'){

        if ($::server_type == 'activemq')
        and ($::hostname == 'amq01') {

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

            file { 'check_jmx_QueueSize.cfg':
                ensure => present,
                path   => '/etc/nrpe.d/check_jmx_QueueSize.cfg',
            }

            file_line { 'check_jmx_QueueSize':
                ensure  => present,
                path    => '/etc/nrpe.d/check_jmx_QueueSize.cfg',
                line    => "command[check_jmx_QueueSize]=${nrpe_plugins_filepath}check_jmx -U service:jmx:rmi:///jndi/rmi://${ipaddress}:11099/jmxrmi -O org.apache.activemq:BrokerName=${hostname},Type=Queue,Destination=example.messaging.push.ios -A QueueSize -w 200000 -c 500000",
                notify  => Service['nrpe'],
                require => File['nrpe.d', 'check_jmx_QueueSize.cfg'],
            }

            @@nagios_service { "check_jmx_QueueSize_${fqdn}":
                    use                   => 'generic-service,graphed-service',
                    service_description   => 'check_nrpe check_jmx_QueueSize',
                    check_command         => 'check_nrpe!check_jmx_QueueSize',
                    normal_check_interval => '3',
                    servicegroups         => 'check_jmx',
                    host_name             => $::fqdn,
                    contact_groups        => $::group,
                    register              => '1',
            }

        }
        else {
            # check_jmx_QueueSize exclusion
            file { 'check_jmx_QueueSize.cfg':
                ensure => absent,
                path   => '/etc/nrpe.d/check_jmx_QueueSize.cfg',
            }

        }
    }
}