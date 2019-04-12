thread_number=$1
echo $thread_number
su - cc -s/bin/bash -c "cd /home/cc/PowerShift/app/Gadget-2.0.7/characterization/cluster;mpirun --mca btl_tcp_if_include eno1 --oversubscribe -np $thread_number --map-by node ~/PowerShift/app/Gadget-2.0.7/Gadget2/Gadget2 ./cluster.param"
