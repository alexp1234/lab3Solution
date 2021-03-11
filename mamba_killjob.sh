#!/bin/bash

# script to kill all jobs that you submitted
# usage:
# $ sh ./mamba_killjob.sh

# prepare for batch submission
user_name=`whoami`

for job in `qstat -u ${user_name} | grep -e "${user_name}" | awk  ' { print $1 } ' `; do
    echo "qdel ${job}"
    qdel ${job}
done

