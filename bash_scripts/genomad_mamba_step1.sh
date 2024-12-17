#!/bin/bash

#SBATCH --partition cpu
#SBATCH --account jgianott_sage
#SBATCH --job-name genomad
#SBATCH --output /scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/logs/%x_%j.out
#SBATCH --error /scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/logs/%x_%j.err
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 24
#SBATCH --mem 100G
#SBATCH --time 1:00:00

# Notes and procedure for GENOMAD pangenomics pipeline 
# https://GENOMAD.org/help/main/artifacts/contigs-db/
# https://merenlab.org/2016/11/08/pangenomics-v2/

# Module loading
module load gcc miniconda3

# Activating what's needed

export PATH="$PATH:/dcsrsoft/spack/external/micromamba"
export MAMBA_ROOT_PREFIX="/scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/"

#To initialize on the cluster :
eval "$(micromamba shell hook --shell=bash)"
#Then activate micromamba
micromamba activate /scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/BACPHLIP/BACPHLIP_MAMBA_ENV

## Variables
GENOMAD_DIR=/scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/GENOMAD

genomes_dir=/scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/genomes

GENOMAD_DB=/scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/GENOMAD/genomad_db

RESULTS_FOLDER=/scratch/jgianott/SAGE/SAGE_2024-2025/gchiche/GENOMAD/RESULTS


## Create directory
mkdir ${RESULTS_FOLDER}



cd ${genomes_dir}


for file in *.fna
do
genomad end-to-end --cleanup ${file} ${RESULTS_FOLDER}/${file}_GENOMAD_OUTPUT ${GENOMAD_DB}
done





micromamba deactivate