thread_number=$1
binary_path=~/PowerShift/app/rodinia_3.1/openmp/nn
dataset_path=~/PowerShift/app/rodinia_3.1/data/nn
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/nn filelist_4 200000 30 90"
