thread_number=$1
binary_path=~/PowerShift/app/rodinia_3.1/openmp/leukocyte
dataset_path=~/PowerShift/app/rodinia_3.1/data/leukocyte
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/OpenMP/leukocyte 50 $thread_number $dataset_path/testfile.avi"
