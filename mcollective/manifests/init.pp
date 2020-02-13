## mcollective recipe

class mcollective {
    case $::operatingsystem {
        'amazon','centos': {

        include mcollective::package, mcollective::config, mcollective::service
        include mcollective::config_agent, mcollective::config_application

        }

        default: {

            notice("mcollective is not supported on $::{operatingsystem}")

        }
    }
}
