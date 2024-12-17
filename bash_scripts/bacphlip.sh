#!/bin/bash

#SBATCH --partition cpu
#SBATCH --account jgianott_sage
#SBATCH --job-name bacphlip
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/logs/%x_%j.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/logs/%x_%j.err
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 24
#SBATCH --mem 20G
#SBATCH --time 1:00:00

# Module loading
module load gcc miniconda3 hmmer

# Activating what's needed
export PATH="$PATH:/dcsrsoft/spack/external/micromamba"
export MAMBA_ROOT_PREFIX="/scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/BACPHLIP"

eval "$(micromamba shell hook --shell=bash)"

micromamba activate /scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/BACPHLIP/BACPHLIP_MAMBA_ENV

# Variables
multigenome_path=/scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/BACPHLIP/mega_fasta.fasta

# Run BACPHLIP
bacphlip -i ${multigenome_path}  --multi_fasta -f