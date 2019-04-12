thread_number=$1
binary_path=~/PowerShift/app/parsec-3.0/pkgs/apps/ferret/inst/amd64-linux.gcc-hooks/bin
dataset_path=~/PowerShift/app/parsec-3.0/inputs
su - cc -s/bin/bash -c "export LD_LIBRARY_PATH=~/PowerShift/app/parsec-3.0/pkgs/libs/hooks/inst/amd64-linux.gcc-hooks/lib/;cd $binary_path; $binary_path/ferret $dataset_path/ferret/corel lsh $dataset_path/ferret/queries 50 20 $thread_number output.txt"
