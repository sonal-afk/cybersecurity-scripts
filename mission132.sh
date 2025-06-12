#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'
 
timestamp()
{
 date "+%Y-%m-%d %H:%M:%S"
}

show_help() #14
{
 echo -e "${BLUE} Usage ${NC}"
 echo "$0 -u <username> -o <output_file> [-v]"
 echo ""
 echo -e "${BLUE} Options ${NC}"
 echo "-u <username> specify username to log (required)"
 echo "-o <output_file> output file path(required)"
 exit 0
}
validate_username()
{
 local username=$1
 if [[ -z "$username" ]]; then
    echo -e "${RED} Error:username empty${NC}" >&2 #26
    return 1
 fi

 if [[ ${#username} -lt 3 || ${#username} -gt 32 ]]; then
    echo -e "${RED}error username must be within 3-32 characters ${NC}" >&2
    return 1
 fi
 
 if [[ ! "$username" =~ ^[a-zA-Z0-9_\.-]+$ ]]; then
    echo -e "${RED} ERROR: Only alphanumeric ones are allowed such as - ,_, ." >&2
    return 1
 fi
return 0
}
log_message()
{
 local message=$1
 local logfile=$2
 echo "[$(timestamp)] $message" >> "$logfile"
}
username=""
output_file=""
verbose=false


while getopts ":u:o:vh" opt; do
    case $opt in
         u)username="$OPTARG";;
         o)output_file="$OPTARG";;
         v)verbose=true;;
         h)show_help;;
         \?)echo -e "${RED} error:invalid option -$OPTARG ${NC}" >&2 ;exit ;;
         :)echo -e "${RED} eror:option -$OPTARG requires an argument ${NC}" >&2; exit ;;
    esac
done

shift $((OPTIND-1))

if [[ -z "$username" || -z "$output_file" ]]; then
    echo -e "${RED} error:missing required arguments ${NC}" >&2 
    show_help
    exit 1
fi

if  ! validate_username "$username"; then 
    exit 1
fi

output_dir=$(dirname "$output_file")
if [[ ! -d "$output_dir" ]]; then
    echo -e "${RED} output directory does not exist${NC}" >&2
    exit 1
fi

if $verbose ; then
    echo -e "${GREEN} [VERBOSE] starting user logging at $(timestamp) ${NC}"
    echo -e "${BLUE} Details:${NC}"
    echo -e "username:$username"
    echo -e "output file:$output_file"
fi

log_message "logged user:$username" "$output_file"

if $verbose ; then
    echo -e "${GREEN} [VERBOSE] successfully logged user ${NC}"
else
    echo -e "${GREEN} use logged successfully ${NC}"
fi
exit 0
