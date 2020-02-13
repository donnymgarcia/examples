## nrpe check_log_push-notification-push recipe

class nrpe::checks::check_log_push-notification-push {

    if ($::env == 'qa') {

        if ($::server_type == 'pushmule') {

            ## nrpe.erb nrpe plugins filepath
            case $::operatingsystem {
                'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
                'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
                default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            }

            file { 'check_log_push-notification-push.cfg':
                ensure => present,
                path   => '/etc/nrpe.d/check_log_push-notification-push.cfg',
            }

            file_line { 'check_log_push-notification-push':
                ensure  => present,
                path    => '/etc/nrpe.d/check_log_push-notification-push.cfg',
                line    => "command[check_log_push-notification-push]=${nrpe_plugins_filepath}check_log -F /data/logs/mule/push-notification-push.log -O /tmp/check_log_push-notification-push.old -q \"ERROR\"",
                notify  => Service['nrpe'],
                require => File['nrpe.d', 'check_log_push-notification-push.cfg'],
            }

            @@nagios_service { "check_log_push-notification-push_${fqdn}":
                use                   => 'generic-service',
                service_description   => 'check_nrpe check_log_push-notification-push',
                check_command         => 'check_nrpe!check_log_push-notification-push',
                normal_check_interval => '3',
                max_check_attempts    => '1',
                servicegroups         => 'check_log',
                host_name             => $::fqdn,
                contact_groups        => $::group,
                register              => '1',
            }
        }
        else {

            file { 'check_log_push-notification-push.cfg':
                ensure => absent,
                path   => '/etc/nrpe.d/check_log_push-notification-push.cfg',
            }
        }
    }
}
