## nrpe package recipe
##

class nrpe::package {

    ## nrpe client

    case $::operatingsystem {
        amazon : { $nrpe = 'nrpe' }
        centos : { $nrpe = 'nagios-nrpe' }
        default: { fail("Module ${module_name} is not supported on ${operatingsystem}") }
    }

    package { 'nrpe':
        ensure  => installed,
        name    => $nrpe,
    }

    ## default plugins

    ## check_nrpe
    package { 'nagios-plugins-nrpe':
        ensure  => installed,
        alias   => 'nagios-plugins-nrpe',
    }

    ## nagios plugins perl dep
    package { 'nagios-plugins-perl':
        ensure  => installed,
        alias   => 'nagios-plugins-perl',
    }

    ## check_load
    package { 'nagios-plugins-load':
        ensure  => installed,
        alias   => 'nagios-plugins-load',
    }

    ## check_swap
    package { 'nagios-plugins-swap':
        ensure  => installed,
        alias   => 'nagios-plugins-swap',
    }

    ## check_disk
    package { 'nagios-plugins-disk':
        ensure  => installed,
        alias   => 'nagios-plugins-disk',
    }

    ## check_ping
    package { 'nagios-plugins-ping':
        ensure  => installed,
        alias   => 'nagios-plugins-ping',
    }

    ## check_procs
    package { 'nagios-plugins-procs':
        ensure  => installed,
        alias   => 'nagios-plugins-procs',
    }

## end default plugins

## instance plugins

## check_dns

    if ( $::server_type == 'nagios') {

        ## check_dns
        package { 'nagios-plugins-dns':
            ensure  => installed,
            alias   => 'nagios-plugins-dns',
        }
    }

## check_log

    if ($::env == 'qa') {
        if ( $::server_type == 'pushmule')
        or ( $::server_type == 'socialcron')
        or ( $::server_type == 'procmule')
        or ( $::server_type == 'pushtomcat')
        or ( $::server_type == 'socialproc')
        or ( $::server_type == 'socialtomcat') {

            ## check_log
            package { 'nagios-plugins-log':
                ensure  => installed,
                alias   => 'nagios-plugins-log',
            }
        }
    }

## end instance plugins

}
