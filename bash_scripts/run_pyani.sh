#!/bin/bash

#SBATCH --partition cpu
#SBATCH --account jgianott_sage
#SBATCH --job-name pyani
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/logs/%x_%j.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/logs/%x_%j.err
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 24
#SBATCH --mem 50G
#SBATCH --time 3:00:00

# Module loading
module load gcc miniconda3 mummer/3.23 blast-plus

# Activating what's needed
export PATH="$PATH:/dcsrsoft/spack/external/micromamba"
export MAMBA_ROOT_PREFIX="/scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/pyani"
eval "$(micromamba shell hook --shell=bash)"
micromamba activate /scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/pyani/pyani_env

# Variables
genomes_dir=/scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/pyani/mini_fasta/
output_dir=/scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/pyani/pyani_output

if [ -f .pyani/pyanidb ]; then
    echo "Database exists. Removing and recreating..."
    rm -rf .pyani/pyanidb
fi

# Index genomes
pyani index -v -i ${genomes_dir} 

# Create database
pyani createdb -v 
# Run pyani
pyani anim -v -i ${genomes_dir} -o ${output_dir}/anim --name "AniM run3" --debug --maxmatch
#pyani anib -v -i ${genomes_dir} -o ${output_dir}/anib --name "AniB run2" --debug
