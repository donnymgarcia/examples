## elasticsearch recipe
##

class elasticsearch {

    include elasticsearch::package, elasticsearch::config, elasticsearch::service

}