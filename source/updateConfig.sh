pgrep_name=$1
core_dist=$2
m=$3


i=0
while [ -z "$(pgrep $pgrep_name)" ];do
    sleep 1
    if [ $i -gt 10 ];then
      exit 1
      echo "something is wrong, not finding processes to controll"
    fi
    i=$(($i + 1))
done

#computing resource adjustment

if [ "$core_dist" = "0-47" ];then
  echo "nothing to change for computing resource!!!"
else
  for pid in $(pgrep "$pgrep_name")
    do
      for id in $(pstree -p $pid |grep -o "([[:digit:]]*)"|grep -o "[[:digit:]]*")
        do sudo taskset -pc $core_dist $id &
    done
  done
fi

if [ "$m" = "1" ];then
  echo "nothing to change for memory allocation!!!"
else
  for pid in $(pgrep "$pgrep_name")
    do
      for id in $(pstree -p $pid |grep -o "([[:digit:]]*)"|grep -o "[[:digit:]]*")
        do sudo migratepages $id all 0 &
    done
  done
fi
