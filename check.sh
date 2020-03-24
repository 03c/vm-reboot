#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

########################################
# Usage
########################################
usage()
{
    echo -e "Check Internet Connectivity"
    echo -e "---------------------------------------"
    echo -e "Usage: $0 -r RETRY_COUNT -s SERVER_COUNT"
    echo -e ""
    echo -e "RETRY_COUNT - Number of times to try each server for a connection."
    echo -e "SERVER_COUNT - How many servers to trye (1-4)."
    echo -e ""
    exit 2
}

########################################
# Extras
########################################
set_variable()
{
  local varname=$1
  shift
  if [ -z "${!varname}" ]; then
    eval "$varname=\"$@\""
  else
    echo -e "Error: $varname already set"
    usage
  fi
}

########################################
# Main Script
########################################
main(){
    #Google DNS, OpenDNS, Quad9 DNS, Cloudflare DNS
    servers=("8.8.8.8" "208.67.222.222" "9.9.9.9" "1.1.1.1")

    failCount=0

    for (( i=0; i<=(($retry - 1)); i++ ))
    do  
        for (( j=0; j<=(($serverCount - 1)); j++ ))
        do  
            echo -e "Trying server $((j+1)), ${servers[$j]}"
            ping -c 4 ${servers[$j]}
            ok=`echo $?`
            if [ $ok -ne 0 ]
              then
                failCount=$((failCount+1))
                echo -e "${RED}Ping failed, ${servers[$j]} ${NC}"
              else
                echo -e "${GREEN}Ping successful, ${servers[$j]} ${NC}"
            fi
            if [ $j -ne $(($serverCount - 1)) ]
              then
                echo -e "Sleeping..."
                sleep 10
            fi
        done
    done

    if [ $failCount -ne 0 ]
      then
        echo -e "${RED}All servers checked ($failCount Failed)${NC}"
        echo -e "${RED}Rebooting Router${NC}"
      else
        echo -e "${GREEN}All servers checked(All Passed)${NC}"
    fi
}

########################################
# Get Options
########################################
unset retry serverCount

while getopts 'r:s:?h' c
do
  case $c in
    r) set_variable retry $OPTARG ;;
    s) set_variable serverCount $OPTARG  ;;
    h|?) usage ;;
  esac
done

[ -z "$retry" ] || [ -z "$serverCount" ] && usage

main