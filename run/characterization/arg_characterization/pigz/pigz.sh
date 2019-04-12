thread_number=$1
su - cc -s/bin/bash -c "cd ~/PowerShift/app/pigz-2.3.4/characterzation/cluster;~/PowerShift/app/pigz-2.3.4/pigz -11 -f -k -p $thread_number ~/PowerShift/app/pigz-2.3.4/characterzation/cluster/input/input_0"
