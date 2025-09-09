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
srun --pty --nodes=1 -t 00:30:00 --exclusive --reservation=ICPP2025Day1 /bin/bash
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
sbatch --res=ICPP2025Day1 pytorch.sb
squeue -u $USER
```
### Simple PyTorch Example using system python modules and pip based install
Lets do the same example but using the our install using the system python
```
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --time=00:30:00
#SBATCH --output=pytorch-syspython.%j.out
#SBATCH --error=pytorch-syspython.%j.err

cd /cosmos/vast/scratch/$USER/examples/mnist
module load cray-python
module load rocm
source /cosmos/vast/scratch/$USER/cray-python-virtualenv/bin/activate
python main.py
```
Save the above script in python-sys.sb and submit it.
```
sbatch --res=ICPP2025Day1 python-sys.sb
```
Did that work? Maybe we are missing a module. See if you can install the right combination using pip and make this work!

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
The tf-test.py is in this repository and is based on an AMD example. Paste above script into tf-test.sb file and submit the job:
```
sbatch  --res=ICPP2025Day1 tf-test.sb
```

### Jax Example using container

For the Jax example we go back to the container approach. There is one already downloaded and converted to Singularity image in the train101 directory. In Thursday's tutorial there will be more in depth use of Jax (pip based installed in that case).
```
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --time=00:05:00
#SBATCH --output=jax.%j.out
#SBATCH --error=jax.%j.err

unset PYTHONSTARTUP
module load singularitypro
singularity exec --bind /cosmos,/home,/scratch /cosmos/vast/scratch/train101/icpp2025/containers/jax-latest.sif python jax-test.py
```
Paste above script into jax-test.sb and submit the job:
```
 sbatch --res=ICPP25Day1 jax-test.sb
```
