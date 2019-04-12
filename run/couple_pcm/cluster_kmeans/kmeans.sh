pgrep_name=mpi_main
thread_number=$(($1 * 24))
core_dist=$2
powercap1=$3
powercap2=$4
memory_allocation=$5


hostfile=/home/cc/PowerShift/script/backendHosts.txt
hostArray=($(cat $hostfile))
cd /home/cc/PowerShift/app/parallel-kmeans/characterization/cluster_kmeans

#set power cap
if [ $(printf "%.0f" $powercap1) -ge 30 ]
then
  for host in "${hostArray[@]}"
  do
    ssh $host "sudo /home/cc/PowerShift/tool/RAPL/RaplSetPower $powercap1 $powercap2" &
  done
else
  echo "something is wrong!!!!"
fi

for host in "${hostArray[@]}"
do
  ssh $host "sudo /home/cc/PowerShift/tool/pcm-master/pcm.x 10 -csv=/mnt/pcm/kmeans/$host" &
done

start_time=`date +%s`
mpirun --mca btl_tcp_if_include eno1 --oversubscribe -hostfile $hostfile -np $thread_number --map-by node ~/PowerShift/app/parallel-kmeans/mpi_main -o -n 600 -i ~/PowerShift/app/input/parallel-kmeans/cluster.result &

PID=$!

while [ -z "$(pgrep $pgrep_name)" ]
do
  sleep 1
done

# update configuration at each node
for host in "${hostArray[@]}"
do
  ssh $host "/home/cc/PowerShift/source/updateConfig.sh $pgrep_name $core_dist $memory_allocation" &
done

wait $PID

for host in "${hostArray[@]}"
do  ssh $host "sudo pkill pcm.x" &
done

end_time=`date +%s`
time=`expr $end_time - $start_time`

sudo touch /mnt/perf/kmeans.txt
sudo chmod 777 /mnt/perf/kmeans.txt
sudo echo $time >> /mnt/perf/kmeans.txt
