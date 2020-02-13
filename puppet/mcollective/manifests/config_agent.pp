## mcollective agent files recipe

class mcollective::config_agent {

    ## mcollective agent files
    file { '/usr/libexec/mcollective/mcollective/agent/discovery.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/discovery.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/filemgr.ddl':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/filemgr.ddl',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/filemgr.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/filemgr.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/package.ddl':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/package.ddl',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/package.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/package.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/process.ddl':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/process.ddl',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/process.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/process.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/puppetd.ddl':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/puppetd.ddl',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/puppetd.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/puppetd.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/rpcutil.ddl':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/rpcutil.ddl',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/rpcutil.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/rpcutil.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/service.ddl':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/service.ddl',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/service.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/service.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/shellcmd.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/shellcmd.rb',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/nrpe.ddl':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/nrpe.ddl',
        notify => Service['mcollective'],
    }

    file { '/usr/libexec/mcollective/mcollective/agent/nrpe.rb':
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/mcollective/agent/nrpe.rb',
        notify => Service['mcollective'],
    }
}
