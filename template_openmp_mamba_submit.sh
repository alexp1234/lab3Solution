#!/bin/sh

# Script to automatically generate submit script
# and automatically submit your jobs, based on
# the number of threads and matrix dimension
# usage:
# $ sh ./mat_multi_mamba_submit.sh ${project_name} ${project_path} ${type}
# . where ${type} could be 1 or 2
# Tasks will be submitted when the ${type} is 2
# for example,
#    $ ./mat_multi_mamba_submit.sh mat_multi_thread /users/qcheng1/3145/threading/mat_multi_thread 1
#    $ ./mat_multi_mamba_submit.sh mat_multi_thread /users/qcheng1/3145/threading/mat_multi_thread 2

# prepare for batch submission

# prj_name is the .cpp name which includes the main function
prj_name=$1

# project path
prj_path=$2

# submit type: 1 - generate submit script; 2 - submit code
type=$3

if [ ! -d "${prj_path}/submit" ] 
then
    mkdir ${prj_path}/submit
else
    rm -f ${prj_path}/submit/*
fi

cd ${prj_path}
# compile the code (this block may be changed according to a project)
echo "g++ -g3 -O1 -Wall -o ${prj_name}.exe ${prj_name}.cpp -lpthread  -std=c++11"

g++ -g3 -O1 -Wall -o ${prj_name}.exe ${prj_name}.cpp -lpthread  -std=c++11

for i in 1 2 4 8 16 32; do
  for n in 100 300 500 800 1000 3000 5000; do
    submitf=./submit/${prj_name}_qsub_t${i}_s${n}.sh
    logf=./submit/${prj_name}_qsub_t${i}_s${n}.log
    amatrix=./data/amatrix_s${n}.txt
    bmatrix=./data/bmatrix_s${n}.txt
    cmatrix=./data/cmatrix_s${n}_t${i}.txt
    echo "#PBS -S /bin/bash" > ${submitf}
    echo "prj_name=${prj_name}" >> ${submitf}
    echo "prj_path=${prj_path}" >> ${submitf}
    echo "#PBS -N ${prj_name}_qsub_t${i}" >> ${submitf}
    echo "#PBS -q mamba" >> ${submitf}
    echo "#PBS -l nodes=1:ppn=${i}" >> ${submitf}
    echo "cd ${prj_path}" >> ${submitf}
    echo "./${prj_name}.exe ${i} ${amatrix} ${bmatrix} ${cmatrix} > ${logf} " >> ${submitf} 
    
    if [ ${type} -eq 2 ]; then 
        qsub ${submitf}
    fi 
  done
done
