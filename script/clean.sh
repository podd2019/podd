# added ssh key in ~/.profile

# add all servers into known_hosts

hostArray=($(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /home/cc/PowerShift/script/hostnames_raw.txt))
i=0
for hostname in "${hostArray[@]}"
do
 ssh $hostname "sudo pkill Rapl;sudo pkill python;sudo pkill Gadget;sudo pkill mpi_main;sudo pkill pigz;sudo pkill engine_par" & 
# ssh $hostname "sudo pkill java" &
done
