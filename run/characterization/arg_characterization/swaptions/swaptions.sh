thread_number=$1
binary_path=~/PowerShift/app/parsec-3.0/pkgs/apps/swaptions/obj/amd64-linux.gcc-hooks
dataset_path=~/PowerShift/app/parsec-3.0/inputs
su - cc -s/bin/bash -c "export LD_LIBRARY_PATH=~/PowerShift/app/parsec-3.0/pkgs/libs/hooks/inst/amd64-linux.gcc-hooks/lib/;cd $binary_path; $binary_path/swaptions -ns 10000 -sm 30000 -nt $thread_number"
