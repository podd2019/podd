thread_number=$1
binary_path=~/PowerShift/app/NU-MineBench-3.0.1/KMeans
dataset_path=/PowerShift/app/NU-MineBench-3.0.1/datasets
su - cc -s/bin/bash -c "cd $binary_path; $binary_path/example -i $dataset_path/kmeans/edge -b -o -p $thread_number"
