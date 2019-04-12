thread_number=$1
binary_path=~/PowerShift/app/rodinia_3.1/openmp/srad
dataset_path=~/PowerShift/app/rodinia_3.1/data/srad
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/srad_v1/srad 10000 0.5 502 458 $thread_number"
