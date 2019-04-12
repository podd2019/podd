thread_number=$1
binary_path=~/PowerShift/app/NU-MineBench-3.0.1/RSEARCH
dataset_path=~/PowerShift/app/NU-MineBench-3.0.1/datasets
su - cc -s/bin/bash -c "cd $binary_path; mpirun --oversubscribe -np $thread_number $binary_path/rsearch -n 1000 -c -E 10 -m ../datasets/rsearch/matrices/RIBOSUM85-60.mat ../datasets/rsearch/Queries/mir-40.stk ../datasets/rsearch/Databasefile/100Kdb.fa"
