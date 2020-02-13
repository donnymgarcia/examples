## nrpe check_log_push-notification-publication recipe

class nrpe::checks::check_log_push-notification-publication {

    if ($::env == 'qa') {

        if ($::server_type == 'pushmule') {

            ## nrpe.erb nrpe plugins filepath
            case $::operatingsystem {
                'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
                'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
                default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            }

            file { 'check_log_push-notification-publication.cfg':
                ensure => present,
                path   => '/etc/nrpe.d/check_log_push-notification-publication.cfg',
            }

            file_line { 'check_log_push-notification-publication':
                ensure  => present,
                path    => '/etc/nrpe.d/check_log_push-notification-publication.cfg',
                line    => "command[check_log_push-notification-publication]=${nrpe_plugins_filepath}check_log -F /data/logs/mule/push-notification-publication.log -O /tmp/check_log_push-notification-publication.old -q \"ERROR\"",
                notify  => Service['nrpe'],
                require => File['nrpe.d', 'check_log_push-notification-publication.cfg'],
            }

            @@nagios_service { "check_log_push-notification-publication_${fqdn}":
                use                   => 'generic-service',
                service_description   => 'check_nrpe check_log_push-notification-publication',
                check_command         => 'check_nrpe!check_log_push-notification-publication',
                normal_check_interval => '3',
                max_check_attempts    => '1',
                servicegroups         => 'check_log',
                host_name             => $::fqdn,
                contact_groups        => $::group,
                register              => '1',
            }
        }
        else {

            file { 'check_log_push-notification-publication.cfg':
                ensure => absent,
                path   => '/etc/nrpe.d/check_log_push-notification-publication.cfg',
            }
        }
    }
}
