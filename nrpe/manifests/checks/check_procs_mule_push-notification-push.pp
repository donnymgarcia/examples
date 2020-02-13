## nrpe check_procs_mule_push-notification-push recipe

class nrpe::checks::check_procs_mule_push-notification-push {

    if ($::server_type == 'pushmule') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_mule_push-notification-push.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_mule_push-notification-push.cfg',
        }

        file_line { 'check_procs_mule_push-notification-push':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_mule_push-notification-push.cfg',
            line    => "command[check_procs_mule_push-notification-push]=${nrpe_plugins_filepath}check_procs -c 1: -a \"java -Dmule.home=/opt/mule-2.2.1 -Dmule.base=/opt/mule/mlbam.mobile.mule.push-notification-push\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_mule_push-notification-push.cfg'],
        }

        @@nagios_service { "check_procs_mule_push-notification-push_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_mule_push-notification-push',
            check_command         => 'check_nrpe!check_procs_mule_push-notification-push',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_mule_push-notification-push.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_mule_push-notification-push.cfg',
        }
    }
}
