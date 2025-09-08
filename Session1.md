# AI and Scientific Research Computing with Kubernetes Tutorial

AI with the AMD Software Stack
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
export TMPDIR=/scratch/train101/job_$SLURM_JOBID
singularity build pytorch-latest.sif docker://rocm/pytorch:latest
```

Do a quick test of the container (more tests in the next session). 

```
module load singularitypro
singularity shell --rocm --bind /scratch,/home,/cosmos pytorch-latest.sif
python -c 'import torch; print("I have this many devices:", torch.cuda.device_count())'
exit
```
