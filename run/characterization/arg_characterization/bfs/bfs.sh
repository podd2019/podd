thread_number=$1
binary_path=/home/cc/PowerShift/app/rodinia_3.1/openmp/bfs
dataset_path=/home/cc/PowerShift/app/rodinia_3.1/data/bfs
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/bfs $thread_number $dataset_path/graph1MW_6.txt"
