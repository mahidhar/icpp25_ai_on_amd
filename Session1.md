# AI with the AMD Software Stack
Session 1 Hands On

## Login

Login to Cosmos as follows. 

```
ssh trainXXX@login01.cosmos.sdsc.edu
```

Please use ssh key that you sent us for access. We do not have passwords for these accounts.

## Get interactive access to a Cosmos compute node with APUs

Cosmos runs the Slurm scheduler and we will use srun for accessing a compute node interactively. There is a reservation in place for today's tutorial (ICPP2025Day1). Command to get an interactive session:

```
srun --pty --nodes=1 -t 00:30:00 --exclusive --reservation=ICPP2025Day1 /bin/bash
```

We will use the VAST based scratch filesystem for all our tests. Change to the location:

```
cd /cosmos/vast/scratch/$USER
```

## Build a container from a docker image

We will set the TMPDIR to the node local NVMe scratch space and then build the container.

```
module load singularitypro
export TMPDIR=/scratch/$USER/job_$SLURM_JOBID
singularity build pytorch-latest.sif docker://rocm/pytorch:latest
```

Do a quick test of the container (more tests in the next session). 

```
module load singularitypro
singularity shell --rocm --bind /scratch,/home,/cosmos pytorch-latest.sif
python -c 'import torch; print("I have this many devices:", torch.cuda.device_count())'
exit
```

### Install using virtual env and the system python

Start by loading the Cray python module on Cosmos. We can then create a virtual environment and pip install the correct version based on the available rocm on Cosmos. 

```
module load cray-python
module load rocm
python -m venv --system-site-packages cray-python-virtualenv
source cray-python-virtualenv/bin/activate
pip3 install --no-cache-dir --pre torch==2.8.0+rocm6.3 --index-url https://download.pytorch.org/whl/
```
We can test as before once the environment is active.

```
python -c 'import torch; print("I have this many devices:", torch.cuda.device_count())'
```

### Install in a conda environment 

Start by installing a base miniconda3 setup.

```
module load rocm
unset PYTHONSTARTUP
curl -LO https://repo.anaconda.com/miniconda/Miniconda3-py310_24.1.2-0-Linux-x86_64.sh
bash ./Miniconda3-* -b -p miniconda3 -s
source ./miniconda3/bin/activate base
```
Create a conda environment for tensorflow and pip install the version matching available rocm.
```
conda create -y -n tensorflow python=3.10
conda activate tensorflow
pip install --user tensorflow-rocm==2.16.2 –f https://repo.radeon.com/rocm/manylinux/rocm-rel-6.3/
python -c 'from tensorflow.python.client import device_lib ; device_lib.list_local_devices()'
```




