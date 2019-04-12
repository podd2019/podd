thread_number=$1
binary_path=~/PowerShift/app/rodinia_3.1/openmp/myocyte
dataset_path=~/PowerShift/app/rodinia_3.1/data/myocyte
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/myocyte.out 100000 12 1 $thread_number"
