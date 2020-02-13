## nrpe check_cucumber_msocial.example.com recipe

class nrpe::checks::check_cucumber_msocial_example_com {

    if ($::server_type == 'nagios') {

        if ($::env == 'prd') {

            ## nrpe.erb nrpe plugins filepath
            case $::operatingsystem {
                'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
                'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
                default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            }

            ## features/msocial.example.com
            file { "${nrpe_plugins_filepath}cucumber-nagios/site-checks/features/msocial.example.com":
                ensure  => directory,
                owner   => root,
                group   => root,
                mode    => '0755',
                alias   => 'msocial.example.com_dir',
            }

            ## msocial.example.com/homepage.feature
            file { "${nrpe_plugins_filepath}cucumber-nagios/site-checks/features/msocial.example.com/homepage.feature":
                owner   => root,
                group   => root,
                mode    => '0755',
                source  => 'puppet:///modules/nrpe/cucumber/msocial.example.com_homepage.feature',
                require => File["${nrpe_plugins_filepath}cucumber-nagios/site-checks/features/msocial.example.com"],
            }

            file { 'check_cucumber_msocial.example.com.cfg':
                ensure => present,
                path   => '/etc/nrpe.d/check_cucumber_msocial.example.com.cfg',
            }

            file_line { 'check_cucumber_msocial.example.com':
                ensure  => present,
                path    => '/etc/nrpe.d/check_cucumber_msocial.example.com.cfg',
                line    => "command[check_cucumber_msocial.example.com]=/usr/bin/cucumber --format Cucumber::Formatter::Nagios --require ${nrpe_plugins_filepath}cucumber-nagios/site-checks/features ${nrpe_plugins_filepath}cucumber-nagios/site-checks/features/msocial.example.com/homepage.feature",
                notify  => Service['nrpe'],
                require => File['nrpe.d', 'check_cucumber_msocial.example.com.cfg'],
            }

            @@nagios_service { "check_cucumber_msocial.example.com_${fqdn}":
                    use                   => 'generic-service',
                    service_description   => 'check_nrpe check_cucumber_msocial.example.com',
                    check_command         => 'check_nrpe!check_cucumber_msocial.example.com',
                    normal_check_interval => '1',
                    servicegroups         => 'check_cucumber',
                    host_name             => $::fqdn,
                    contact_groups        => $::group,
                    register              => '1',
            }
        }

    }
    else {
        # check_cucumber_msocial.example.com exclusion
        file { 'check_cucumber_msocial.example.com.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_cucumber_msocial.example.com.cfg',
        }

    }
}
