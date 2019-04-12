server=$1
hostArray=($(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' hostnames_raw.txt))
i=0
sudo systemctl restart nfs-kernel-server
sleep 10
for hostname in "${hostArray[@]}"
do
  ssh $hostname "sudo mkdir -p /mnt;sudo mount $server:/exports/example /mnt" &
done
