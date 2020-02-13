## elasticsearch config recipe
##

class elasticsearch::config {

    ## elasticsearch.yml
    file { '/etc/sysconfig/elasticsearch':
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('elasticsearch/sysconfig_elasticsearch.erb'),
        notify  => Service['elasticsearch'],
        require => Package['elasticsearch'],
    }

    ## elasticsearch.yml
    file { '/etc/elasticsearch/elasticsearch.yml':
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('elasticsearch/elasticsearch.erb'),
        notify  => Service['elasticsearch'],
        require => Package['elasticsearch'],
    }

    ## kibana ebs volume
    file { '/mnt/esdata':
        ensure => 'directory',
        owner  => root,
        group  => root,
    }

    ## esdata ebs volume
    mount { '/mnt/esdata':
        ensure  => 'mounted',
        device  => '/dev/xvdf',
        fstype  => 'ext3',
        options => 'defaults,noatime',
        dump    => '1',
        pass    => '2',
        atboot  => true,
        require => File['/mnt/esdata'],
    }

    ## esdata ebs dirs
    file { '/var/lib/elasticsearch':
        ensure  => 'link',
        target  => '/mnt/esdata/elasticsearch',
        require => Mount['/mnt/esdata'],
    }

}
