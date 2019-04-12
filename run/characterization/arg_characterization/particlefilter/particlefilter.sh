thread_number=$1
binary_path=~/PowerShift/app/rodinia_3.1/openmp/particlefilter
dataset_path=~/PowerShift/app/rodinia_3.1/data/particlefilter
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/particle_filter -x 1024 -y 1024 -z 500 -np 1000"
