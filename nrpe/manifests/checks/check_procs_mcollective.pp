## nrpe check_procs_mcollective recipe

class nrpe::checks::check_procs_mcollective {

    ## nrpe.erb nrpe plugins filepath
    case $::operatingsystem {
        'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
        'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

    file { 'check_procs_mcollective.cfg':
        ensure => present,
        path   => '/etc/nrpe.d/check_procs_mcollective.cfg',
    }

    file_line { 'check_procs_mcollective':
        ensure  => present,
        path    => '/etc/nrpe.d/check_procs_mcollective.cfg',
        line    => "command[check_procs_mcollective]=${nrpe_plugins_filepath}check_procs -c 1: -a \"ruby /usr/sbin/mcollectived\"",
        notify  => Service['nrpe'],
        require => File['nrpe.d', 'check_procs_mcollective.cfg'],
    }

    @@nagios_service { "check_procs_mcollective_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_mcollective',
            check_command         => 'check_nrpe!check_procs_mcollective',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
    }
}
