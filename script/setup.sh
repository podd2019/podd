# added ssh key in ~/.profile

# add all servers into known_hosts

hostArray=($(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' hostnames_raw.txt))
i=0
for hostname in "${hostArray[@]}"
do
  if [ $(( $i % 2 )) -eq 0 ]; then
    echo $hostname >> ./frontendHosts.txt
  else
    echo $hostname >> ./backendHosts.txt
  fi
  i=$(($i + 1))  
done

#copy host list to front and back end
frontend_hostname=$(head -n 1 frontendHosts.txt)
scp ./frontendHosts.txt $frontend_hostname:/home/cc/PowerShift/script/

backend_hostname=$(head -n 1 backendHosts.txt)
scp ./backendHosts.txt $backend_hostname:/home/cc/PowerShift/script/


# Gadget

# kmeans
#mkdir -p ~/PowerShift/app/input/parallel-kmeans

#pigz

#sudo chmod -R 777 /exports/example/input/pigz

#ssh $frontend_hostname "mkdir ~/PowerShift/app/input"
#ssh $backend_hostname "mkdir ~/PowerShift/app/input"

#scp -r ~/PowerShift/app/input/Gadget-2.0.7 $frontend_hostname:~/PowerShift/app/input/
#scp -r ~/PowerShift/app/input/parallel-kmeans $backend_hostname:~/PowerShift/app/input/



