thread_number=$1
binary_path=~/PowerShift/app/rodinia_3.1/openmp/hotspot
dataset_path=~/PowerShift/app/rodinia_3.1/data/hotspot
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/hotspot 1024 1024 200000 $thread_number $dataset_path/temp_1024 $dataset_path/power_1024 output.out"
