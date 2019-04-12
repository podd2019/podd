#global variables
RAPL_POWER_LMT=~/PowerShift/tool/RAPL/RaplSetPower
RAPL_POWER_MON=~/PowerShift/tool/RAPL/RaplPowerMonitor_1s

app=$1
cmd=~/PowerShift/run/single//"$app".sh
result_folder=~/PowerShift/data/characterization/full/$app
mkdir -p $result_folder


#for POWER_CAP in 70 80 90 100 110 120;do
for i in {11..11};do
    for j in {1..1};do
        for k in {1..1};do
            for m in {1..1};do
                for POWER_CAP in 50 60 70 80 90 100 110 120;do
                #for POWER_CAP in 120;do
                    k=$j
		    thread_number=$((($i+1)*($j+1)*($k+1)))
                    start_time=`date +%s`
                    sudo rm -f PowerResults.txt
                    sudo $RAPL_POWER_MON >/dev/null &
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
                    $cmd $thread_number $core_dist $POWER_CAP $POWER_CAP $m
		    # kill power monitor
                    sudo pkill Rapl
		    # reset power cap
		    sudo $RAPL_POWER_LMT 125 125
                    sudo chmod 755 PowerResults.txt
                    end_time=`date +%s`
                    time=`expr $end_time - $start_time`
                    socket1_power=`cat PowerResults.txt |awk '{ if($2 > 0 ) {total += $2} } END { print total/NR }'`
                    socket2_power=`cat PowerResults.txt |awk '{ if($3 > 0 ) {total += $3} } END { print total/NR }'`
                    echo $i $j $k $m $POWER_CAP $time $socket1_power $socket2_power >> $result_folder/"$app"_characterization.results
                    sleep 30
                done
            done
        done
    done
done
