thread_number=$1
binary_path=~/PowerShift/app/NU-MineBench-3.0.1/ScalParC
dataset_path=~/PowerShift/app/NU-MineBench-3.0.1/datasets
su - cc -s/bin/bash -c "cd $binary_path; $binary_path/scalparc $dataset_path/ScalParC/para_F26-A64-D250K/F26-A64-D250K.tab 250000 1 2 $thread_number"
