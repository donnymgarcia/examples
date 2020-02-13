## mcollective config recipe

class mcollective::config {

    ## ensure directories
    file { [ '/etc/mcollective',
        '/usr/libexec/mcollective',
        '/usr/libexec/mcollective/mcollective',
        '/usr/libexec/mcollective/mcollective/facts',
        '/usr/libexec/mcollective/mcollective/agent',
        '/usr/libexec/mcollective/mcollective/application' ]:
        ensure => 'directory',
    }

    ## server -- client.cfg
    if ($::server_type == 'controller') {
        file { '/etc/mcollective/client.cfg':
            owner   => root,
            group   => root,
            mode    => '0640',
            content => template('mcollective/client.erb'),
            notify  => Service['mcollective'],
        }

        file { '/etc/rabbitmq':
            ensure => 'directory',
        }

        ## server -- rabbitmq.conf
        file { '/etc/rabbitmq/rabbitmq.conf':
            owner   => root,
            group   => root,
            mode    => '0640',
            content => template('mcollective/rabbitmq.erb'),
            notify  => Service['rabbitmq-server'],
            require => File['/etc/rabbitmq'],
        }

        ## server -- mcshellcmd
        file { '/usr/sbin/mcshellcmd':
            owner  => root,
            group  => root,
            mode   => '0700',
            source => 'puppet:///modules/mcollective/mcshellcmd',
        }
    }

    case $::facility {
        'am0'  : { $mco_host = 'controller01.ops' }
        'am1'  : { $mco_host = 'controller01.ops' }
        'am2'  : { $mco_host = 'controller01.ops' }
        default: { notice('controller server cannot be determined') }
    }

    ## client -- server.cfg
    file { '/etc/mcollective/server.cfg':
        owner   => root,
        group   => root,
        mode    => '0640',
        content => template('mcollective/server.erb'),
        notify  => Service['mcollective'],
    }

    ## facter_facts.rb
    file { '/usr/libexec/mcollective/mcollective/facts/facter_facts.rb':
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('mcollective/facter_facts.erb'),
        notify  => Service['mcollective'],
    }
}
