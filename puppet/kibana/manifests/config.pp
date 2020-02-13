## kibana config recipe
##

class kibana::config {

    ## kibana.conf
    file { '/etc/httpd/conf.d/kibana.conf':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/kibana/kibana.conf',
        require => Exec['kibana_install'],
    }

    ## /etc/kibana
    file { '/etc/kibana':
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => '0655',
    }

    ## kibana httpd.conf
    file { '/etc/httpd/conf/httpd.conf':
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/kibana/httpd.conf',
        notify  => Service['httpd'],
        require => [ Exec['kibana_install'], Package['httpd.x86_64'] ],
    }

    ## passwd
    file { '/etc/kibana/passwd':
        owner   => root,
        group   => apache,
        mode    => '0640',
        source  => 'puppet:///modules/nagios/passwd',
        notify  => Service['httpd'],
        require => [ Exec['kibana_install'], File['/etc/kibana'], Package['httpd.x86_64']],
    }

    ## kibana.conf
    file { '/usr/share/kibana/config.js':
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('kibana/config.erb'),
        require => Exec['kibana_install'],
    }

}
