#!/usr/bin/env bash

# Replace the contents of this script with your software setup!

module load rocm
module load cray-python
source /cosmos/vast/scratch/train101/icpp2025/cray-python-virtualenv/bin/activate
export LD_LIBRARY_PATH=/cosmos/vast/scratch/train101/icpp2025/rccl/build:/cosmos/vast/scratch/train101/icpp2025/ofi-rccl/lib64:/opt/cray/libfabric/1.20.1/lib64:/opt/rocm-6.3.0/lib:$LD_LIBRARY_PATH

if [[ `which mpicc | wc -l` -eq 0 ]]; then
   echo " "
   echo " "
   echo "WARNING: could not find MPI in the system, tests involving MPI will fail"
   echo " "
   echo " "
fi
