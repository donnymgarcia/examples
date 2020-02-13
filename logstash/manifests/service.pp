## logstash service recipe
##

class logstash::service {

    ## service logstash
    service { 'logstash':
        ensure     => running,
        alias      => 'logstash',
        hasstatus  => true,
        hasrestart => true,
        status     => '/sbin/service logstash status | grep "is running"',
        require    => Exec['logstash_install'],
    }

}
