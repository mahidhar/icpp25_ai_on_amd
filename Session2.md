## AI and Scientific Research Computing with Kubernetes Tutorial
Session 2 Hands On 

### Simple PyTorch Example using Containers
Start by cloning the PyTorch examples directory
```
cd /cosmos/vast/scratch/$USER
git clone https://github.com/pytorch/examples.git
cd examples/mnist
```
Try an interactive job first (make sure you are in the mnist directory before these steps):
```
srun --pty --nodes=1 -t 00:30:00 --exclusive  /bin/bash
unset PYTHONSTARTUP
module load singularitypro
singularity exec --bind /cosmos,/home,/scratch /cosmos/vast/scratch/train101/icpp2025/containers/pytorch-latest.sif python main.py
```

