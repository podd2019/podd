thread_number=$1
binary_path=~/PowerShift/app/parsec-3.0/pkgs/apps/bodytrack/obj/amd64-linux.gcc-hooks/TrackingBenchmark
dataset_path=~/PowerShift/app/parsec-3.0/inputs
su - cc -s/bin/bash -c "export LD_LIBRARY_PATH=~/PowerShift/app/parsec-3.0/pkgs/libs/hooks/inst/amd64-linux.gcc-hooks/lib/;cd $binary_path; $binary_path/bodytrack $dataset_path/bodytrack/sequenceB_261 4 261 4000 5 0 $thread_number"
