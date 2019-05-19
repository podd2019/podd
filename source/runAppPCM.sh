app1=$1
j1=$2
k1=$3
m1=$4
powerCap1=$5
app2=$6
j2=$7
k2=$8
m2=$9
powerCap2=${10}

hostsFile1=~/PowerShift/script/frontendHosts.txt
hostsFile2=~/PowerShift/script/backendHosts.txt

headNode1=$(head -n 1 $hostsFile1)
headNode2=$(head -n 1 $hostsFile2)

cmd1=~/PowerShift/run/couple_pcm/"$app1"_"$app2"/"$app1".sh
cmd2=~/PowerShift/run/couple_pcm/"$app1"_"$app2"/"$app2".sh


# run front app
if [ $j1 -eq 1 ];then
  pwrcap1=$powerCap1
  pwrcap2=$powerCap1
  if [ $k1 -eq 1 ];then
    core_dist=0-47
  else
    core_dist=0-23
  fi
else
  pwrcap1=$(python -c "print $powerCap1 * 2 - 15")
  pwrcap2=15
  if [ $k1 -eq 1 ];then
    core_dist=0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46
  else
    core_dist=0,2,4,6,8,10,12,14,16,18,20,22
  fi
fi
thread_number=$((12*($j1+1)*($k1+1)))


ssh $headNode1 "$cmd1 $thread_number $core_dist $pwrcap1 $pwrcap2 $m1" &
PID1=$!

#run back app

if [ $j2 -eq 1 ];then
  pwrcap1=$powerCap2
  pwrcap2=$powerCap2
  if [ $k2 -eq 1 ];then
    core_dist=0-47
  else
    core_dist=0-23
  fi
else
  pwrcap1=$(python -c "print $powerCap2 * 2 - 15")
  pwrcap2=15
  if [ $k2 -eq 1 ];then    
    core_dist=0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46
  else
    core_dist=0,2,4,6,8,10,12,14,16,18,20,22
  fi
fi
thread_number=$((12*($j2+1)*($k2+1)))

ssh $headNode2 "$cmd2 $thread_number $core_dist $pwrcap1 $pwrcap2 $m2" &
PID2=$!

#runtime

wait $PID1
wait $PID2

