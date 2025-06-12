#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

logfile="loopmaster_report.log"

if [ $# -ne 1 ]; then
   echo -e  "${RED}usage:$0 <directory_path> ${NC}"
   exit 1
fi
directory=$1

if [ ! -d "$directory" ]; then
   echo -e "${RED}error:directory is empty${NC}"
   exit 1
fi

echo "loopmaster report -$(date)" > "$logfile"

found_logs=false

for file in "$directory"/*.log; do
    if [ ! -e "$file" ]; then
       continue
    fi
   found_logs=true
   error_count=$(grep -ci "Error" "$file")
  
  if [ "$error_count" -gt 5 ]; then
     echo -e "${RED} [ALERT]$(basename "$file") -> $error_count ERRORs ${NC}"
  else
     echo -e "${GREEN} [OK] $(basename "$file") -> $error_count ERRORs ${NC}"
     echo "[$(date)] $(basename "$file") -> $error_count ERRORs" >> "$logfile"
  fi
done

if [ "$found_logs" = false ]; then
    echo -e "${YELLOW} no .log files found in directory.${NC}"
fi
exit 0
