#!/usr/bin/env bash
#
#SBATCH -J adalmms  # give the job a name   
#***SBATCH --partition=batch_default ***
# 
# 1 node, 1 CPU per node (total 1 CPU), wall clock time of hours
#
#SBATCH -N 1                  ## Node count
#SBATCH --ntasks-per-node=1   ## Processors per node
#SBATCH --ntasks=1            ## Tasks
#SBATCH --gres=gpu:1          ## GPUs
#SBATCH --cpus-per-task=12     ## CPUs per task; number of threads of each task
#SBATCH -t 256:00:00          ## Walltime
#SBATCH --mem=60GB
#SBATCH -p lianglab,research
#SBATCH --exclude=euler[01-16],euler[21-23],euler28
#SBATCH --output=./eulerlog/o_device_job_name_%A_%a.out
#SBATCH --error=./eulerlog/o_device_job_name_%A_%a.err
source ~/.bashrc
conda activate /srv/home/zxu444/anaconda3/envs/lnext

echo "======== testing CUDA available ========"
echo "running on machine: " $(hostname -s)
python - << EOF
import torch
print(torch.cuda.is_available())
print(torch.cuda.device_count())
print(torch.cuda.current_device())
print(torch.cuda.device(0))
print(torch.cuda.get_device_name(0))
EOF

echo "======== run with different inputs ========"
echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID

# Read the specific line from the input file based on array task ID
LINE=$(sed "${SLURM_ARRAY_TASK_ID}q;d" slurm_array_txt/low_light.txt)
# Extract model_id and latency from the line
gain=$(echo $LINE | cut -d',' -f1 | xargs)
sigma=$(echo $LINE | cut -d',' -f2 | xargs)

echo "======== Running evaluation ========"
# echo "jobArray noise: $noise_type"
echo "jobarray gain: $gain"
echo "jobarray sigma: $sigma"

# Export the variables so they're available to the evaluation script
export noise_type="low_light"
export gain
export sigma

# Run the evaluation script
bash ov_noise.sh
