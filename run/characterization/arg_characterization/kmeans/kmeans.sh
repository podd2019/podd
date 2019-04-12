thread_number=$1
su - cc -s/bin/bash -c "cd ~/PowerShift/app/parallel-kmeans/characterization/cluster_kmeans;mpiexec --oversubscribe -n $thread_number ../../mpi_main -o -n 2 -i ./cluster.result"
