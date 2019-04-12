hostArray=($(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /home/cc/PowerShift/script/hostnames_raw.txt))

for hostname in "${hostArray[@]}"
do
  ssh $hostname "sudo pkill Rapl;sudo /home/cc/PowerShift/tool/RAPL/RaplPowerMonitor &" &
done
