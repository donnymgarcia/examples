## elasticsearch service recipe
##

class elasticsearch::service {

    ## service elasticsearch
    service { 'elasticsearch':
        ensure     => running,
        alias      => 'elasticsearch',
        hasstatus  => true,
        hasrestart => true,
        require    => Package['elasticsearch'],
    }

}

