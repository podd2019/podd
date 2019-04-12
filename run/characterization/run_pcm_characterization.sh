#global variables
RAPL_POWER_MON=~/PowerShift/tool/RAPL/RaplPowerMonitor_1s
RAPL_POWER_LMT=~/PowerShift/tool/RAPL/RaplSetPower

app=$1
env_file=~/PowerShift/run/characterization/arg_characterization/$app/env.sh
source $env_file
cmd=~/PowerShift/run/characterization/arg_characterization/$app/"$app".sh
result_folder=~/PowerShift/data/characterization/pcm/$app
mkdir -p $result_folder


#for POWER_CAP in 70 80 90 100 110 120;do
for i in {11..11};do
    for j in {0..1};do
        for k in {0..1};do
            for m in {0..1};do
                for POWER_CAP in 60 70 80 90 100 110 120 125;do
                    thread_number=$((($i+1)*($j+1)*($k+1)))
                    echo $thread_number
                    start_time=`date +%s`
                    sudo rm -f PowerResults.txt
                    sudo $RAPL_POWER_MON >/dev/null &
                    sudo $RAPL_POWER_LMT $POWER_CAP $POWER_CAP
	            if [ $j -eq 1 ];then
                        if [ $k -eq 1 ];then
                            core_dist=0-47
                        else
                            core_dist=0-23
                        fi
                    else
                        if [ $k -eq 1 ];then
                            core_dist=0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46
                        else
                            core_dist=0,2,4,6,8,10,12,14,16,18,20,22
                        fi
                    fi	
                    sudo numactl --interleave=0-$m ~/PowerShift/tool/pcm-master/pcm.x -csv=$result_folder/"$app"-"$i"-"$j"-"$k"-"$m"-"$POWER_CAP".pcm -- $cmd $thread_number &
                    PID=$!
                    sleep 1
                    echo $pgrep_name
                    for pid in $(pgrep "$pgrep_name");do for id in $(pstree -p $pid |grep -o "([[:digit:]]*)"|grep -o "[[:digit:]]*");do sudo taskset -pc $core_dist $id & done;done
                    wait $PID
		    # kill power monitor
                    sudo pkill Rapl
		    # reset power cap
		    sudo $RAPL_POWER_LMT 125 125
                    sudo chmod 755 PowerResults.txt
                    end_time=`date +%s`
                    time=`expr $end_time - $start_time`
                    socket1_power=`cat PowerResults.txt |awk '{ total += $2 } END { print total/NR }'`
                    socket2_power=`cat PowerResults.txt |awk '{ total += $3 } END { print total/NR }'`
                    echo $i $j $k $m $POWER_CAP $time $socket1_power $socket2_power >> $result_folder/"$app"_characterization.results
                    sleep 5
                done
            done
        done
    done
done
