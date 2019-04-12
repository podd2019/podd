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
