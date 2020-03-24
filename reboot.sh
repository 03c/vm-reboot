#!/bin/bash

########################################
# Usage
########################################
usage()
{
    echo -e "VM Router Reboot Usage"
    echo -e "---------------------------------------"
    echo -e "Usage: $0 -i IP -u USERNAME -p PASSWORD"
    echo -e "IP - IP address of your VM router."
    echo -e "USERNAME - Username of your VM router."
    echo -e "PASSWORD - Password of your VM router."
    echo -e ""
    exit -e 2
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
    echo "Error: $varname already set"
    usage
  fi
}

########################################
# Main Script
########################################
main(){
    # Time need for valid request
    unixTime=$(date +%s)
    # Make each request unique
    count=000
    # Random Number for request
    nonce=`echo $((10000 + RANDOM % 99999))`

    # Construct Login URL
    loginBase64=`echo -n "$username:$password" | base64`
    loginUrl="https://$ip/login?arg=$loginBase64&_n=$nonce&_=$unixTime$(printf %03d $((++count)))"

    # Login and Save Token
    token=$(curl -v --insecure "$loginUrl")

    # Reboot
    rebootConfirmUrl="https://$ip//snmpSet?oid=1.3.6.1.2.1.69.1.1.3.0=2;2;&_n=$nonce"
    curl -v --insecure --header "Cookie: credential=$token" "$rebootConfirmUrl"

    # ensure we are logged out again
    logoutUrl="https://$ip/logout?_n=$nonce&_=$unixTime$(printf %03d $((++count)))"
    curl -v --insecure --header "Cookie: credential=$token" "$logoutUrl"
}

########################################
# Get Options
########################################
unset ip username password

while getopts 'i:u:p:?h' c
do
  case $c in
    i) set_variable ip $OPTARG ;;
    u) set_variable username $OPTARG  ;;
    p) set_variable password $OPTARG  ;;
    h|?) usage ;;
  esac
done

[ -z "$ip" ] || [ -z "$username" ] || [ -z "$password" ] && usage

main