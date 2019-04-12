thread_number=$1
binary_path=~/PowerShift/app/NU-MineBench-3.0.1/PLSA
dataset_path=~/PowerShift/app/NU-MineBench-3.0.1/datasets
su - cc -s/bin/bash -c "cd $binary_path; $binary_path/parasw.mt ../datasets/PLSA/30k_1.txt ../datasets/PLSA/30k_2.txt ../datasets/PLSA/pam120.bla 600 400 3 3 20 $thread_number"
