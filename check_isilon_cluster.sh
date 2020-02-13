#!/bin/bash
##
## check script for isilon clusterHealth
## 
## clusterHealth
## 
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/sfw/bin:/usr/sfw/sbin:/opt/sfw/bin:/opt/sfw/sbin:/usr/local/bin:/usr/local/sbin:/opt/csw/bin:/usr/ucb:/usr/cluster/bin:/usr/ccs/bin:/opt/mlb/bin:/opt/bin

host=$1
cs=$2
oid=".1.3.6.1.4.1.12124.1.1.2.0"
#snmppath=/usr/sfw/bin/
CSTAT=false
WSTAT=false
USTAT=false
OKSTAT=false

## collect state
ISILON_CLUSTERHEALTH=`snmpget -v2c -c $cs $host $oid | awk -F= '{print $2}' | sed s/\ INTEGER:\ //g`
echo -n "ISILON - clusterHealth: $ISILON_CLUSTERHEALTH"

if [ x$ISILON_CLUSTERHEALTH = "x" ]
    then
        echo "SNMP response fail"
        CSTAT=true
else
    if [ x$ISILON_CLUSTERHEALTH = "x0" ]
        then
            echo " (ok)"
            OKSTAT=true
    else
        if [ x$ISILON_CLUSTERHEALTH = "x1" ]
            then
                echo " (attn)"
                CSTAT=true
        else
            if [ x$ISILON_CLUSTERHEALTH = "x2" ]
                then
                    echo " (down)"
                    CSTAT=true
            else
                if [ x$ISILON_CLUSTERHEALTH = "x3" ]
                    then
                        echo " (invalid)"
                        USTAT=true
                else
                    echo " (unknown)"
                    USTAT=true
                fi
            fi
        fi
    fi
fi

## check result
if [ $CSTAT == "true" ]
    then
        exit 2
else
    if [ $WSTAT == "true" ]
        then
            exit 1 
    else
        if [ $OKSTAT == "true" ]
            then
                exit 0
        else
            if [ $USTAT == "true" ]
                then
                    exit 3
            fi
        fi
    fi
fi
