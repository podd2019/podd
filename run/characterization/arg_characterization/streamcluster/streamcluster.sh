thread_number=$1
binary_path=~/PowerShift/app/parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc-hooks/bin
dataset_path=~/PowerShift/app/parsec-3.0/inputs
su - cc -s/bin/bash -c "export LD_LIBRARY_PATH=~/PowerShift/app/parsec-3.0/pkgs/libs/hooks/inst/amd64-linux.gcc-hooks/lib/;cd $binary_path; $binary_path/streamcluster 10 20 128 20000 1000 5000 none output.txt $thread_number"
