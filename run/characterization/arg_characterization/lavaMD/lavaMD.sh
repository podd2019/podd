thread_number=$1
binary_path=~/PowerShift/app/rodinia_3.1/openmp/lavaMD
dataset_path=~/PowerShift/app/rodinia_3.1/data/lavaMD
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/lavaMD -cores $thread_number -boxes1d 30"
