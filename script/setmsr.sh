# added ssh key in ~/.profile

# add all servers into known_hosts

hostArray=($(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' hostnames_raw.txt))
i=0
for hostname in "${hostArray[@]}"
do
 ssh $hostname "sudo modprobe msr" & 
done
