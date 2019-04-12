thread_number=$1
binary_path=~/PowerShift/app/STREAM
dataset_path=~/PowerShift/app/STREAM
su - cc -s/bin/bash -c "export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/stream_c.exe"
