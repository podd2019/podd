thread_number=$1
binary_path=~/PowerShift/app/NU-MineBench-3.0.1/SVM-RFE
dataset_path=~/PowerShift/app/NU-MineBench-3.0.1/datasets
su - cc -s/bin/bash -c "export NUM_OMP_THREADS=$thread_number;cd $binary_path; $binary_path/svm_mkl $dataset_path/SVM-RFE/outData.txt 253 15154 300"
