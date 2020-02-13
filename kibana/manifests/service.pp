## kibana service recipe
##

class kibana::service {

    service { 'httpd':
        ensure     => running,
        alias      => 'httpd',
        hasstatus  => true,
        hasrestart => true,
        require    => Exec['kibana_install'],
    }

}
