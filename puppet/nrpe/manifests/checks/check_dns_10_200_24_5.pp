## nrpe check_dns_10_200_24_5 recipe

class nrpe::checks::check_dns_10_200_24_5 {

    if ($::server_type == 'nagios') {

        if ($::facility == 'am2')
            and ($::env == 'prd') {

            ## nrpe.erb nrpe plugins filepath
            case $::operatingsystem {
                'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
                'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
                default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            }

            file { 'check_dns_10.200.24.5.cfg':
                ensure => present,
                path   => '/etc/nrpe.d/check_dns_10.200.24.5.cfg',
            }

            file_line { 'check_dns_10.200.24.5':
                ensure  => present,
                path    => '/etc/nrpe.d/check_dns_10.200.24.5.cfg',
                line    => "command[check_dns_10.200.24.5]=${nrpe_plugins_filepath}check_dns -H www.google.com -s 10.200.24.5 -w 3 -c 6",
                notify  => Service['nrpe'],
                require => File['nrpe.d', 'check_dns_10.200.24.5.cfg'],
            }

            @@nagios_service { "check_dns_10.200.24.5_${fqdn}":
                    use                   => 'generic-service,graphed-service',
                    service_description   => 'check_nrpe check_dns_10.200.24.5',
                    check_command         => 'check_nrpe!check_dns_10.200.24.5',
                    normal_check_interval => '3',
                    servicegroups         => 'check_dns',
                    host_name             => $::fqdn,
                    contact_groups        => $::group,
                    register              => '1',
            }
        }
    }
    else {
        # check_dns_10.200.24.5 exclusion
        file { 'check_dns_10.200.24.5.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_dns_10.200.24.5.cfg',
        }
    }

}
