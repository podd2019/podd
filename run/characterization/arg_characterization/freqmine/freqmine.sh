thread_number=$1
binary_path=~/PowerShift/app/parsec-3.0/pkgs/apps/freqmine/obj/amd64-linux.gcc-hooks
dataset_path=~/PowerShift/app//parsec-3.0/inputs
su - cc -s/bin/bash -c "export LD_LIBRARY_PATH=~/PowerShift/app/parsec-3.0/pkgs/libs/hooks/inst/amd64-linux.gcc-hooks/lib/;export OMP_NUM_THREADS=$thread_number;cd $binary_path; $binary_path/freqmine $dataset_path/freqmine/webdocs_250k.dat 10000"
