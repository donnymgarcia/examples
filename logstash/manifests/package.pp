## logstash package recipe
##

class logstash::package {

    ## logstash
    exec { 'logstash_install':
        ##command => '/usr/bin/wget http://deploy01.ops/ops/logstash-1.1.9-monolithic.jar ;
        ##           /bin/mv /opt/logstash/logstash-1.1.9-monolithic.jar /opt/logstash/logstash.jar',
        command => '/usr/bin/wget http://deploy01.ops/ops/logstash-1.2.0-flatjar.jar ;
                   /bin/mv /opt/logstash/bin/logstash-1.2.0-flatjar.jar /opt/logstash/bin/logstash.jar',
        cwd     => '/opt/logstash/bin',
        creates => '/opt/logstash/bin/logstash.jar',
        require => File['/opt/logstash/bin'],
    }

}