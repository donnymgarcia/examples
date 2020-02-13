## mcollective package recipe

class mcollective::package {

    if ($::server_type == 'controller') {

        ## mcollective internal repo
        package { 'mcollective-client':
            ensure   => installed,
            provider => 'rpm',
            source   => 'http://deploy01.ops/ops/mcollective-client-2.0.0-6.el6.noarch.rpm',
        }

        ## mcollective internal repo
        package { 'rabbitmq-server':
            ensure   => installed,
            provider => 'rpm',
            source   => 'http://deploy01.ops/ops/rabbitmq-server-2.6.1-1.el6.noarch.rpm',
        }

        ## rabbitmq plugins install
        exec { 'rabbitmq_plugins_install':
            command => '/usr/bin/wget http://www.rabbitmq.com/releases/plugins/v2.6.1/amqp_client-2.6.1.ez ;
                    /usr/bin/wget http://www.rabbitmq.com/releases/plugins/v2.6.1/rabbitmq_stomp-2.6.1.ez',
            path    => '/usr/lib/rabbitmq/lib/rabbitmq_server-2.6.1/plugins',
            timeout => '900',
            require => File['/etc/rabbitmq'],
            creates => '/usr/lib/rabbitmq/lib/rabbitmq_server-2.6.1',
        }
    }


    ## mcollective internal repo
    package { 'mcollective':
        ensure   => installed,
        provider => 'rpm',
        source   => 'http://deploy01.ops/ops/mcollective-2.0.0-6.el6.noarch.rpm',
        require  => Package['mcollective-common'],
    }

    ## mcollective-common internal repo
    package { 'mcollective-common':
        ensure   => installed,
        provider => 'rpm',
        source   => 'http://deploy01.ops/ops/mcollective-common-2.0.0-6.el6.noarch.rpm',
        require  => [ Package['rubygem-stomp'], Package['sys-proctable'], Package['rubygem-systemu'] ],
    }

    package { 'rubygem-stomp':
        ensure   => installed,
        provider => 'rpm',
        source   => 'http://deploy01.ops/ops/rubygem-stomp-1.2.2-1.el6.noarch.rpm',
    }

    package { 'rubygem-systemu':
        ensure   => installed,
        provider => 'rpm',
        source   => 'http://deploy01.ops/ops/rubygem-systemu-1.2.0-3.el6.noarch.rpm',
    }

    ## sys-proctable
        package { 'sys-proctable':
        ensure   => installed,
        alias    => 'sys-proctable',
        provider => 'gem',
    }

}
