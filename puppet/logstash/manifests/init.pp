## logstash recipe
##

class logstash {

    include logstash::package, logstash::config, logstash::service

}