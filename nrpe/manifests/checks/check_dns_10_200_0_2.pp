## nrpe check_dns_10_200_0_2 recipe

class nrpe::checks::check_dns_10_200_0_2 {

    if ($::server_type == 'nagios') {

        if ($::facility == 'am2')
            and ($::env == 'prd') {

            ## nrpe.erb nrpe plugins filepath
            case $::operatingsystem {
                'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
                'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
                default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            }

            file { 'check_dns_10.200.0.2.cfg':
                ensure => present,
                path   => '/etc/nrpe.d/check_dns_10.200.0.2.cfg',
            }

            file_line { 'check_dns_10.200.0.2':
                ensure  => present,
                path    => '/etc/nrpe.d/check_dns_10.200.0.2.cfg',
                line    => "command[check_dns_10.200.0.2]=${nrpe_plugins_filepath}check_dns -H www.google.com -s 10.200.0.2 -w 3 -c 6",
                notify  => Service['nrpe'],
                require => File['nrpe.d', 'check_dns_10.200.0.2.cfg'],
            }

            @@nagios_service { "check_dns_10.200.0.2_${fqdn}":
                    use                   => 'generic-service,graphed-service',
                    service_description   => 'check_nrpe check_dns_10.200.0.2',
                    check_command         => 'check_nrpe!check_dns_10.200.0.2',
                    normal_check_interval => '3',
                    servicegroups         => 'check_dns',
                    host_name             => $::fqdn,
                    contact_groups        => $::group,
                    register              => '1',
            }
        }
    }
    else {
        # check_dns_10.200.0.2 exclusion
        file { 'check_dns_10.200.0.2.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_dns_10.200.0.2.cfg',
        }
    }

}
