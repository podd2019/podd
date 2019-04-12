thread_number=$1
binary_path=/home/cc/PowerShift/app/rodinia_3.1/openmp/heartwall
dataset_path=/home/cc/PowerShift/app/rodinia_3.1/data/heartwall
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/heartwall $dataset_path/test.avi 104 $thread_number"
