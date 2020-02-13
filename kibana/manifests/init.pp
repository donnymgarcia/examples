## kibana recipe
##

class kibana {

    include kibana::package, kibana::config, kibana::service

}