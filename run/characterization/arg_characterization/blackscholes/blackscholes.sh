thread_number=$1
binary_path=/home/cc/PowerShift/app/parsec-3.0/pkgs/apps/blackscholes/obj/amd64-linux.gcc-hooks
dataset_path=/home/cc/PowerShift/app/parsec-3.0/inputs
su - cc -s/bin/bash -c "export LD_LIBRARY_PATH=~/PowerShift/app/parsec-3.0/pkgs/libs/hooks/inst/amd64-linux.gcc-hooks/lib/;cd $binary_path; $binary_path/blackscholes $thread_number $dataset_path/blackscholes/in_10M.txt out_10M.txt"
