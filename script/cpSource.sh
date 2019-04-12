# added ssh key in ~/.profile

# add all servers into known_hosts

hostArray=($(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' hostnames_raw.txt))
i=0
for hostname in "${hostArray[@]}"
do
 #scp ~/PowerShift/source/* $hostname:~/PowerShift/source/ &
 scp -r ~/PowerShift/run/* $hostname:~/PowerShift/run/ &
 #scp ~/.bashrc $hostname:~/.bashrc &
done
