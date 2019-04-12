su - cc -s/bin/bash -c "export OMP_NUM_THREADS=2;mpirun --oversubscribe -np 27 ~/PowerShift/app/lulesh/lulesh2.0 -s 60 -p -i 10"
