## mcollective application files recipe

class mcollective::config_application {

    ## mcollective application files
    file { '/usr/libexec/mcollective/mcollective/application/controller.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/controller.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/facts.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/facts.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/filemgr.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/filemgr.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/find.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/find.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/help.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/help.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/inventory.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/inventory.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/package.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/package.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/pgrep.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/pgrep.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/ping.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/ping.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/plugin.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/plugin.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/puppetd.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/puppetd.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/rpc.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/rpc.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/service.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/service.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/application/nrpe.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/application/nrpe.rb',
        notify => Service['mcollective'],
    }
}