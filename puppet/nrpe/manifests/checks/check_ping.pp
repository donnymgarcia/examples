## nrpe check_ping recipe

class nrpe::checks::check_ping {

    @@nagios_service { "check_ping_${fqdn}":
            use                   => 'generic-service,graphed-service',
            service_description   => 'check_ping',
            check_command         => 'check_ping!200.0,30%!500.0,60%',
            normal_check_interval => '5',
            servicegroups         => 'check_ping',
            host_name             => $::fqdn,
            contact_groups        => $::group,
            register              => '1',
        }

}
