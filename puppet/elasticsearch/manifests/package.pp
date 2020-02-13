## elasticsearch package recipe
##

class elasticsearch::package {

    ## elasticsearch rpm
    package { 'elasticsearch':
        ensure   => installed,
        provider => 'rpm',
        source   => 'http://deploy01.ops/ops/elasticsearch-0.90.3.noarch.rpm',
    }

    ## elasticsearch rpm
    package { 'java-1.6.0-openjdk-devel.x86_64':
        ensure => installed,
        alias  => 'openjdk-devel', 
    }

}
