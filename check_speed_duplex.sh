#!/bin/bash
#
# Name:: check_speed_duplex.sh
# Description:: check for speed duplex
#
TP_SPEED=1000
FIBRE_SPEED=10000
STATUS=0

## list interfaces
list=`cat /proc/net/dev | awk -F: '{print $1}' | egrep -v '(Inter|face|lo|bond)' |sort`

echo -n "SPEED DUPLEX: "

## loop all interfaces
for i in `echo $list` ; do
 
  ## determine type
  TYPE=`ethtool $i | grep "Supported ports" | awk -F:\  '{print $2}'`
  ## determine network interfaces entry
  NETWORK_INTERFACES_ENABLED=`grep "^iface $i" /etc/network/interfaces`

  if [ "${NETWORK_INTERFACES_ENABLED}x" == "x" ]; then
      ## skip
      DEVICE="NOT IN USE"
  else
    ## twisted pair
    if [ "${TYPE}x" == "[ TP ]x" ] ; then
      SPEED=`ethtool $i | grep "Speed" | awk -F:\  '{print $2}' | awk -FM '{print $1}'`

        ## tp speed eval
        if [ "${SPEED}x" == "${TP_SPEED}x" ] ; then
          echo -n "OK $i - " 
        else
          echo -n "NOK $i - CONFIGURED SPEED: (${TP_SPEED}) != "
          STATUS=1
        fi
      ## print current
      echo -n "CURRENT SPEED: ($SPEED) "
    fi

    ## fibre
    if [ "${TYPE}x" == "[ FIBRE ]x" ] ; then
      SPEED=`ethtool $i | grep "Speed" | awk -F:\  '{print $2}' | awk -FM '{print $1}'`

      ## fibre speed eval
      if [ "${SPEED}x" == "${FIBRE_SPEED}x" ] ; then
        echo -n "OK $i - " 
      else
        echo -n "NOK $i - CONFIGURED SPEED: (${FIBRE_SPEED}) != "
        STATUS=1
      fi

      ## print current
      echo -n "CURRENT SPEED: ($SPEED) "
    fi
  fi

done
echo
## exit status
exit $STATUS