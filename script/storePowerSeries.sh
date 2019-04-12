hostArray=($(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /home/cc/PowerShift/script/hostnames_raw.txt))

dir=$1
sudo mkdir -p /exports/example/power/$dir
sudo chown nobody:nogroup /exports/example/power/$dir

for hostname in "${hostArray[@]}"
do
  ssh $hostname "sudo pkill Rapl;sudo cp /home/cc/PowerShift/tool/RAPL/PowerResults.txt /mnt/power/$dir/$hostname"
done
