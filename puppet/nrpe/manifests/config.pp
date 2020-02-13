## nrpe config recipe
##

class nrpe::config {

    ## nagios_host
    if ( $::facility == 'am0' ) {
        case $env {
            'dev': { $nagios_host = '10.0.24.196' } ## nagios01.ops.am0.dev
            'qa' : { $nagios_host = '' }
            'prd': { $nagios_host = '' }
        }
    }
    elsif ( $::facility == 'am1' ) {
        case $env {
            'dev': { $nagios_host = '' }
            'qa' : { $nagios_host = '10.193.24.221' } ## nagios01.ops.am1.qa
            'prd': { $nagios_host = '10.192.24.175' } ## nagios01.ops.am1.prd
        }
    }
    elsif ( $::facility == 'am2' ) {
        case $env {
            'dev': { $nagios_host = '' }
            'qa' : { $nagios_host = '' }
            'prd': { $nagios_host = '10.200.32.11' } ## nagios01.ops.am2.prd
        }
    }
    else {
        notice('nagios_host server cannot be determined')
    }

    ## file nrpe.cfg
    file { '/etc/nagios/nrpe.cfg':
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('nrpe/nrpe.erb'),
        notify  => Service['nrpe'],
        require => Package ['nrpe'],
    }

    file { '/etc/nrpe.d':
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => '0644',
        alias   => 'nrpe.d',
        require => Package ['nrpe'],
    }

    ## ec2_credentials.cfg
    file { '/etc/nagios/credentials':
        ensure => 'directory',
        owner  => root,
        group  => nagios,
        mode   => '0750',
    }

    ## ec2_credentials.cfg
    file { '/etc/nagios/credentials/ec2_credentials.cfg':
        ensure  => present,
        owner   => root,
        group   => nagios,
        mode    => '0750',
        source  => 'puppet:///modules/nrpe/ec2_credentials.cfg',
        require => File['/etc/nagios/credentials'],
    }

    ## nagios.pem
    file { '/etc/nagios/credentials/nagios.pem':
        ensure  => present,
        owner   => root,
        group   => nagios,
        mode    => '0750',
        source  => 'puppet:///modules/nrpe/nagios.pem',
        require => File['/etc/nagios/credentials'],
    }
    ## /etc/nagios/nrpe.d link for mco nrpe
    file { '/etc/nagios/nrpe.d':
        ensure  => 'link',
        target  => '/etc/nrpe.d',
        require => Package['nrpe'],
    }
}
