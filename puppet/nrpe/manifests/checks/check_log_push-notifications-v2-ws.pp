## nrpe check_log_push-notifications-v2-ws recipe

class nrpe::checks::check_log_push-notifications-v2-ws {

    if ($::env == 'qa') {

        if ($::server_type == 'pushtomcat') {

            ## nrpe.erb nrpe plugins filepath
            case $::operatingsystem {
                'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
                'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
                default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            }

            file { 'check_log_push-notifications-v2-ws.cfg':
                ensure => present,
                path   => '/etc/nrpe.d/check_log_push-notifications-v2-ws.cfg',
            }

            file_line { 'check_log_push-notifications-v2-ws':
                ensure  => present,
                path    => '/etc/nrpe.d/check_log_push-notifications-v2-ws.cfg',
                line    => "command[check_log_push-notifications-v2-ws]=${nrpe_plugins_filepath}check_log -F /data/logs/push/push-notifications-v2-ws.log -O /tmp/check_log_push-notifications-v2-ws.old -q \"ERROR\"",
                notify  => Service['nrpe'],
                require => File['nrpe.d', 'check_log_push-notifications-v2-ws.cfg'],
            }

            @@nagios_service { "check_log_push-notifications-v2-ws_${fqdn}":
                use                   => 'generic-service',
                service_description   => 'check_nrpe check_log_push-notifications-v2-ws',
                check_command         => 'check_nrpe!check_log_push-notifications-v2-ws',
                normal_check_interval => '3',
                max_check_attempts    => '1',
                servicegroups         => 'check_log',
                host_name             => $::fqdn,
                contact_groups        => $::group,
                register              => '1',
            }
        }
        else {

            file { 'check_log_push-notifications-v2-ws.cfg':
                ensure => absent,
                path   => '/etc/nrpe.d/check_log_push-notifications-v2-ws.cfg',
            }
        }
    }
}
