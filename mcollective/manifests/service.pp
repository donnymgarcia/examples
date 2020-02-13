## mcollective service recipe

class mcollective::service {

    if ($::server_type == 'controller') {
        ## mco
        service { 'rabbitmq-server':
            ensure     => running,
            alias      => 'rabbitmq-server',
            hasstatus  => true,
            hasrestart => true,
            require    => Exec['rabbitmq_plugins_install'],
        }
    }

    service { 'mcollective':
        ensure     => running,
        alias      => 'mcollective',
        hasstatus  => true,
        hasrestart => true,
        require    => Package['mcollective'],
    }
}
