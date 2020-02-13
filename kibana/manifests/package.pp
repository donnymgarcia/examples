## kibana package recipe
##

class kibana::package {

    ## httpd
    package { 'httpd.x86_64':
        ensure  => installed,
        alias   => 'httpd_kibana_prereq',
    }

    ## kibana
    exec { 'kibana_install':
        command => '/usr/bin/curl http://deploy01.ops/ops/kibana.tar.gz | /bin/tar xz',
        cwd     => '/usr/share',
        creates => '/usr/share/kibana',
    }

}