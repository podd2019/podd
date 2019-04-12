thread_number=$1
binary_path=~/PowerShift/app/rodinia_3.1/openmp/lud
dataset_path=~/PowerShift/app/rodinia_3.1/data/lud
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/omp/lud_omp -n $thread_number -s 120000"
