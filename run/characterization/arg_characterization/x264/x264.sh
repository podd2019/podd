thread_number=$1
binary_path=~/PowerShift/app/parsec-3.0/pkgs/apps/x264/obj/amd64-linux.gcc-hooks
dataset_path=~/PowerShift/app/parsec-3.0/inputs
su - cc -s/bin/bash -c "export LD_LIBRARY_PATH=~/PowerShift/app/parsec-3.0/pkgs/libs/hooks/inst/amd64-linux.gcc-hooks/lib/;cd $binary_path; $binary_path/x264 --quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads $thread_number -o test.264 $dataset_path/x264/phases_long.yuv 1920x1080 --frames 10000"
