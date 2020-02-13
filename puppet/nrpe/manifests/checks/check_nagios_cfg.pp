## nrpe check_nagios_cfg recipe

class nrpe::checks::check_nagios_cfg {

    if ($::server_type == 'nagios') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        ## check_nagios_cfg.sh
        file { "${nrpe_plugins_filepath}check_nagios_cfg.sh":
            owner   => root,
            group   => root,
            mode    => '0755',
            source  => 'puppet:///modules/nrpe/check_nagios_cfg.sh',
        }

        file { 'check_nagios_cfg.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_nagios_cfg.cfg',
        }

        file_line { 'check_nagios_cfg':
            ensure  => present,
            path    => '/etc/nrpe.d/check_nagios_cfg.cfg',
            line    => "command[check_nagios_cfg]=${nrpe_plugins_filepath}check_nagios_cfg.sh",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_nagios_cfg.cfg'],
        }

        @@nagios_service { "check_nagios_cfg_${fqdn}":
                use                   => 'generic-service',
                service_description   => 'check_nrpe check_nagios_cfg',
                check_command         => 'check_nrpe!check_nagios_cfg',
                normal_check_interval => '3',
                servicegroups         => 'check_nagios_cfg',
                host_name             => $::fqdn,
                contact_groups        => $::group,
                register              => '1',
        }

    }
    else {
        # check_nagios_cfg exclusion
        file { 'check_nagios_cfg.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_nagios_cfg.cfg',
        }

    }
}
