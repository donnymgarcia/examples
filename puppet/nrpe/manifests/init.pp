## nrpe client recipe
##

class nrpe {

    include nrpe::package, nrpe::config, nrpe::service

    ## default definition modules
    include nrpe::checks::check_disk_xvda1
    include nrpe::checks::check_load
    include nrpe::checks::check_mem
    include nrpe::checks::check_ping
    include nrpe::checks::check_procs_mcollective
    include nrpe::checks::check_swap

    ## custom definitions modules
    include nrpe::checks::check_cloudwatch_cpu_utilization
    include nrpe::checks::check_cloudwatch_network_in
    include nrpe::checks::check_cloudwatch_network_out
    include nrpe::checks::check_cucumber_mpush_bamnetworks_com
    include nrpe::checks::check_cucumber_msocial_bamnetworks_com
    include nrpe::checks::check_cucumber_qampush_bamnetworks_com
    include nrpe::checks::check_cucumber_qamsocial_bamnetworks_com
    include nrpe::checks::check_disk_xvdf
    include nrpe::checks::check_disk_xvdg
    include nrpe::checks::check_dns_10_0_0_2
    include nrpe::checks::check_dns_10_0_24_5
    include nrpe::checks::check_dns_10_192_0_2
    include nrpe::checks::check_dns_10_192_24_5
    include nrpe::checks::check_dns_10_192_25_5
    include nrpe::checks::check_dns_10_193_0_2
    include nrpe::checks::check_dns_10_193_24_5
    include nrpe::checks::check_dns_10_193_25_5
    include nrpe::checks::check_dns_10_200_0_2
    include nrpe::checks::check_dns_10_200_24_5
    include nrpe::checks::check_dns_10_200_25_5
    include nrpe::checks::check_jmx_current_threads_busy
    include nrpe::checks::check_jmx_heap_memory_usage
    include nrpe::checks::check_jmx_queue_size
    include nrpe::checks::check_log_push-notification-publication
    include nrpe::checks::check_log_push-notification-push
    include nrpe::checks::check_log_push-notifications-v2-ws
    include nrpe::checks::check_log_social-cron-processor-mule
    include nrpe::checks::check_log_social-processor-mule
    include nrpe::checks::check_nagios_cfg
    include nrpe::checks::check_procs_activemq
    include nrpe::checks::check_procs_cassandra
    include nrpe::checks::check_procs_elasticsearch
    include nrpe::checks::check_procs_httpd
    include nrpe::checks::check_procs_mule_push-notification-publication
    include nrpe::checks::check_procs_mule_push-notification-push
    include nrpe::checks::check_procs_mule_social-cron-processor-mule
    include nrpe::checks::check_procs_mule_social-processor-mule
    include nrpe::checks::check_procs_named
    include nrpe::checks::check_procs_opscenter
    include nrpe::checks::check_procs_tomcat-broker
    include nrpe::checks::check_procs_tomcat6
    include nrpe::checks::check_procs_syslog-ng
    include nrpe::checks::check_procs_wowza
    include nrpe::checks::syslog-ng-crit
    include nrpe::checks::syslog-ng-warn

}
