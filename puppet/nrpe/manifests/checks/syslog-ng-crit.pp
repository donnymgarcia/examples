## syslog-ng-crit recipe

class nrpe::checks::syslog-ng-crit {

    @@nagios_service { "syslog-ng-crit_${fqdn}":
            use                    => 'passive-service',
            service_description    => 'syslog-ng-crit',
            passive_checks_enabled => '1',
            servicegroups          => 'syslog-ng',
            host_name              => $::fqdn,
            contact_groups         => $::group,
            register               => '1',
        }

}
