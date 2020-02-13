## check_nagios_cfg.sh: Managed by Puppet
#!/bin/bash
##
## check script for nagios.cfg
##
##

nagios_path=/usr/sbin/
nagios_etc_path=/etc/nagios/

## check -v output

nagios_out=`${nagiospath}nagios -v ${nagios_etc_path}nagios.cfg | egrep "(Things look okay|Error processing object config files)"`

if [ "x$nagios_out" = "x   Error processing object config files!" ]; then
    echo "NAGIOS.CFG NOK: $nagios_out"
    exit 2
elif [ "x$nagios_out" = "xThings look okay - No serious problems were detected during the pre-flight check" ]; then
    echo "NAGIOS.CFG OK: $nagios_out"
    exit 0
else
    echo "NAGIOS.CFG UNKNOWN: unexpected result"
    exit 3
fi
