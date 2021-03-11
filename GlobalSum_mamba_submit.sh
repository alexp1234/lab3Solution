#!/bin/sh

# Script to automatically generate submit script
# and automatically submit your jobs, based on
# the number of threads and matrix dimension
# Usage:
# $ sh ./globalsum_mamba_submit.sh ${project_name} ${project_path} ${start_value}  ${end_value} ${is_to_run}
# 
# For example,
#    $ ./globalsum_mamba_submit.sh GlobalSum /users/qcheng1/3145/GlobalSum -100000000 100000001 1

# prepare for batch submission
user_name=`whoami`

# prj_name is the .cpp name which includes the main function
prj_name=$1

# project path
prj_path=$2

# start value
start_value=$3

# end value
end_value=$4

# is_to_run 1: yes (generating scripts and submit them to cluster)
#         0: no (only generating scripts)
is_to_run=$5

module load mpich

if [ ! -d "${prj_path}/submit" ] 
then
    mkdir ${prj_path}/submit
else
    rm -f ${prj_path}/submit/*
fi

cd ${prj_path}

# compile the code (this block may be changed according to a project)
echo "make clean"
make clean

rm -f ${prj_name}_${user_name}_qsub_*

echo "make all"
make all

for i in 1 2 4 8 16 32; do
    if [[ $i -le 16 ]]
    then
        nodes=1
        cores=$i
    else
        tmp=`expr $i + 15`
        cores=16
        nodes=`expr ${tmp} / ${cores}`
    fi
    submitf=./submit/${prj_name}_${user_name}_qsub_t${i}.sh
    logf=./submit/${prj_name}_${user_name}_qsub_t${i}.log

    echo "#PBS -S /bin/bash" > ${submitf}
    echo "#PBS -N ${prj_name}_${user_name}_qsub_t${i}" >> ${submitf}
    echo "#PBS -q mamba" >> ${submitf}
    echo "#PBS -l nodes=${nodes}:ppn=${cores}" >> ${submitf}
    echo "module load mpich" >> ${submitf}
    echo "cd ${prj_path}" >> ${submitf}
    echo "ulimit -S -s 10240" >> ${submitf}
    echo "mpirun -n ${i} ./${prj_name} ${start_value} ${end_value} > ${logf} " >> ${submitf} 
    
    if [[ ${is_to_run} -eq 1 ]]; then 
        echo "qsub ${submitf}"
        qsub ${submitf}
    fi 
  done

