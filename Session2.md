# AI with the AMD Software Stack
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
srun --pty --nodes=1 -t 00:30:00 --exclusive --reservation=ICPP25Day1 /bin/bash
unset PYTHONSTARTUP
module load singularitypro
singularity exec --bind /cosmos,/home,/scratch /cosmos/vast/scratch/train101/icpp2025/containers/pytorch-latest.sif python main.py
exit
```
Remember to exit out of the interactive session at the end to release the node.

### Simple PyTorch Example using Containers and a batch script
We will run the same example using a batch script now. Copy the following into a batch script called pytorch.sb:

```
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --time=00:30:00
#SBATCH --output=pytorch.%j.out
#SBATCH --error=pytorch.%j.err
cd /cosmos/vast/scratch/$USER/examples/mnist
unset PYTHONSTARTUP
module load singularitypro
singularity exec --bind /cosmos,/home,/scratch /cosmos/vast/scratch/train101/icpp2025/containers/pytorch-latest.sif python main.py
```
Now we can submit the job to queue and use the squeue command to check its status
```
sbatch pytorch.sb
squeue -u $USER
```
### Simple TensorFlow script using our conda based install
We will use the install that is already in the train101 account. You are welcome to try your own install (make sure you do it in the VAST directory and not your home directory).
```
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --time=00:30:00
#SBATCH --output=tf.%j.out
#SBATCH --error=tf.%j.err

### Unset the system startup
unset PYTHONSTARTUP

### Setup conda environment
. /cosmos/vast/scratch/train101/icpp2025/miniconda3/etc/profile.d/conda.sh
conda activate tensorflow

### Load the rocm module
module load rocm

### Run the job
python tf-test.py
```
The tf-test.py is in this repository and is based on an AMD example.
