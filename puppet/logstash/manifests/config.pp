## logstash config recipe
##

class logstash::config {

    ## graylog clients
    file { "/opt/logstash/etc/${server_type}_logstash.conf":
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template("logstash/${group}/${server_type}_logstash.erb"),
        notify  => Service['logstash'],
        require => Exec['logstash_install'],
    }

    ## /opt/logstash bin etc
    file { [ '/opt/logstash',
              '/opt/logstash/bin',
              '/opt/logstash/etc' ]:
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => '0640',
    }

    ## logstash_service
    file { '/etc/init.d/logstash':
        owner   => root,
        group   => root,
        mode    => '0755',
        content => template('logstash/logstash.erb'),
        require => Exec['logstash_install'],
    }

}


