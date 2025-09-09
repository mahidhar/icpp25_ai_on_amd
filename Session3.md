# AI with the AMD Software Stack
Session 3 Hands On

## Profiling Examples
We will be using AMD's examples. Start by cloning:
```
git https://github.com/amd/HPCTrainingExamples
cd HPCTrainingExamples/MLExamples/PyTorch_Profiling
```
In the setup.sh file replace the module load command with these lines:
```
module load rocm
module load cray-python
source /cosmos/vast/scratch/train101/icpp2025/cray-python-virtualenv/bin/activate
export LD_LIBRARY_PATH=/cosmos/vast/scratch/train101/icpp2025/rccl/build:/cosmos/vast/scratch/train101/icpp2025/ofi-rccl/lib64:/opt/cray/libfabric/1.20.1/lib64:
/opt/rocm-6.3.0/lib:$LD_LIBRARY_PATH
```

### Some prep work by downloading CIFAR-10 dataset
Use the download option on the test script
```
module load rocm
module load cray-python
source /cosmos/vast/scratch/train101/icpp2025/cray-python-virtualenv/bin/activate
export PROFILER_TOP_DIR=$PWD
export MASTER_ADDR=localhost
export MASTER_PORT=1234
python train_cifar_100.py --download-only --data-path data
```
### Do a test run with no profiling

Copy the slurm_noprofiling.sb file to the HPCTrainingExamples/MLExamples/PyTorch_Profiling/no-profiling directory and submit it.
```
sbatch --res=ICPP25Day1 slurm_noprofiling.sb
```
Inspect the output and see how the example is performing. The slurm script is set up to use all 4 APUs on the node.

### PyTorch profiler run

Copy the slurm_pytorch_profile.sb file to the HPCTrainingExamples/MLExamples/PyTorch_Profiling/torch-profiler directory and submit it.
```
sbatch --res=ICPP25Day1 slurm_pytorch_profile.sb
```
Once the job completes you will see summary statistics in the output file and a json file will be created. Download this json file to your laptop. You can go to the following site and open it.
```
https://ui.perfetto.dev/
```
### rocprofv3 run

Copy the slurm_rocprofv3.sb file to the HPCTrainingExamples/MLExamples/PyTorch_Profiling/rocprofv3 directory and submit it.
```
sbatch --res=ICPP25Day1 slurm_rocprofv3.sb
```
Once this run completes you should see a directory labeled after the node used and it will contain a lot of csv files with details. We can download them to the laptop and examine them.

## RCCL Benchmarks

Download and build the tests (need to do this on a compute node)

```
module load rocm
git clone https://github.com/ROCmSoftwarePlatform/rccl-tests.git
cd rccl-tests
export MPI_HOME=/opt/cray/pe/mpich/8.1.30/ofi/cray/17.0
export ROCM_PATH=/opt/rocm-6.3.0
export MPI=1
export NCCL_HOME=/cosmos/vast/scratch/train101/icpp2025/rccl/build
make -j4
```
Once the builds are done, copy over the rccl submit scripts from this repository and modify them to use your build. Note that the original RCCL install should still point to the train101 location (that build takes hours!).
```
sbstch --res=ICPP2025Day1 rccl-test-1node-normal.sb
sbatch --res=ICPP2025Day1 rccl-test-1node-verbose.sb
```
The verbose run will give many details and we can inspect the output to check the parameters logged.

