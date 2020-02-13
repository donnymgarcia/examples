## nrpe service recipe
##

class nrpe::service {

    ## service nrpe
    service { 'nrpe':
        ensure     => running,
        alias      => 'nrpe',
        hasstatus  => true,
        hasrestart => true,
        require    => Package['nrpe'],
    }
}
