## syslog-ng-warn recipe

class nrpe::checks::syslog-ng-warn {

    @@nagios_service { "syslog-ng-warn_${fqdn}":
            use                    => 'passive-service',
            service_description    => 'syslog-ng-warn',
            passive_checks_enabled => '1',
            servicegroups          => 'syslog-ng',
            host_name              => $::fqdn,
            contact_groups         => $::group,
            register               => '1',
        }

}