## nrpe check_procs_wowza recipe

class nrpe::checks::check_procs_wowza {

    if ($::server_type == 'wowzamilb') {

        ## nrpe.erb nrpe plugins filepath
        case $::operatingsystem {
            'amazon': { $nrpe_plugins_filepath = '/usr/lib64/nagios/plugins/' }
            'centos': { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
            default : { $nrpe_plugins_filepath = '/usr/lib/nagios/plugins/' }
        }

        file { 'check_procs_wowza.cfg':
            ensure => present,
            path   => '/etc/nrpe.d/check_procs_wowza.cfg',
        }

        file_line { 'check_procs_wowza':
            ensure  => present,
            path    => '/etc/nrpe.d/check_procs_wowza.cfg',
            line    => "command[check_procs_wowza]=${nrpe_plugins_filepath}check_procs -c 2: -a \"java -server -Xmx5G -server -Djava.net.preferIPv4Stack=true -Dcom.sun.management.jmxremote=true -Dcom.wowza.wms.runmode=service -Dcom.wowza.wms.native.base=linux -Dcom.wowza.wms.AppHome=/usr/local/WowzaMediaServer -Dcom.wowza.wms.ConfigURL= -Dcom.wowza.wms.ConfigHome=/usr/local/WowzaMediaServer -cp /usr/local/WowzaMediaServer/bin/wms-bootstrap.jar com.wowza.wms.bootstrap.Bootstrap start\"",
            notify  => Service['nrpe'],
            require => File['nrpe.d', 'check_procs_wowza.cfg'],
        }

        @@nagios_service { "check_procs_wowza_${fqdn}":
            use                   => 'generic-service',
            service_description   => 'check_nrpe check_procs_wowza',
            check_command         => 'check_nrpe!check_procs_wowza',
            normal_check_interval => '3',
            servicegroups         => 'check_procs',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }
    }
    else {

        file { 'check_procs_wowza.cfg':
            ensure => absent,
            path   => '/etc/nrpe.d/check_procs_wowza.cfg',
        }
    }
}
