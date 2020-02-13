## nrpe check_procs_mule_social-cron-processor-mule recipe

class nrpe::checks::check_procs_mule_social-cron-processor-mule {

    if ($::server_type == 'socialcron') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_mule_social-cron-processor-mule.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_mule_social-cron-processor-mule.cfg',
        }

        file_line { 'check_procs_mule_social-cron-processor-mule':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_mule_social-cron-processor-mule.cfg',
            line    => "command[check_procs_mule_social-cron-processor-mule]=${nrpe_plugins_filepath}check_procs -c 1: -a \"java -Dmule.home=/opt/mule-2.2.1 -Dmule.base=/opt/mule/mlbam.mobile.mule.social-cron-processor-mule\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_mule_social-cron-processor-mule.cfg'],
        }

        @@nagios_service { "check_procs_mule_social-cron-processor-mule_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_mule_social-cron-processor-mule',
            check_command         => 'check_nrpe!check_procs_mule_social-cron-processor-mule',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_mule_social-cron-processor-mule.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_mule_social-cron-processor-mule.cfg',
        }
    }
}
