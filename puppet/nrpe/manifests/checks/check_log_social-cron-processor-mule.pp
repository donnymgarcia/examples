## nrpe check_log_social-cron-processor-mule recipe

class nrpe::checks::check_log_social-cron-processor-mule {

    if ($::env == 'qa') {

        if ($::server_type == 'socialcron.disable') {

            ## nrpe.erb nrpe plugins filepath
            case $::operatingsystem {
                'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
                'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
                default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            }

            file { 'check_log_social-cron-processor-mule.cfg':
                ensure => present,
                path   => '/etc/nrpe.d/check_log_social-cron-processor-mule.cfg',
            }

            file_line { 'check_log_social-cron-processor-mule':
                ensure  => present,
                path    => '/etc/nrpe.d/check_log_social-cron-processor-mule.cfg',
                line    => "command[check_log_social-cron-processor-mule]=${nrpe_plugins_filepath}check_log -F /data/logs/mule/social-cron-processor-mule.log -O /tmp/check_log_social-cron-processor-mule.old -q \"ERROR\"",
                notify  => Service['nrpe'],
                require => File['nrpe.d', 'check_log_social-cron-processor-mule.cfg'],
            }

            @@nagios_service { "check_log_social-cron-processor-mule_${fqdn}":
                use                   => 'generic-service',
                service_description   => 'check_nrpe check_log_social-cron-processor-mule',
                check_command         => 'check_nrpe!check_log_social-cron-processor-mule',
                normal_check_interval => '3',
                max_check_attempts    => '1',
                servicegroups         => 'check_log',
                host_name             => $::fqdn,
                contact_groups        => $::group,
                register              => '1',
            }
        }
        else {

            file { 'check_log_social-cron-processor-mule.cfg':
                ensure => absent,
                path   => '/etc/nrpe.d/check_log_social-cron-processor-mule.cfg',
            }
        }
    }
}
