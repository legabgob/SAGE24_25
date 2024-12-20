#!/bin/bash

####--------------------------------------
## SLURM options
####--------------------------------------
#SBATCH --job-name=Runtax
#SBATCH --account=jgianott_sage
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4  # Number of threads for taxmyphage
#SBATCH --mem=2G
#SBATCH --time=1:00:00
#SBATCH --output=/scratch/jgianott/SAGE/SAGE_2024-2025/jvujevic/logs/%x_%j.out
#SBATCH --error=/scratch/jgianott/SAGE/SAGE_2024-2025/jvujevic/logs/%x_%j.err

####--------------------------------------
## Preparation
####--------------------------------------

# Run ca avant de run la derniere ligne puis le mettre en vert
#module load gcc/11.4.0
#module load miniconda3/22.11.1

# Create a new conda environment named 'taxmyphage'
#conda create -n taxmyphage -c conda-forge -c bioconda taxmyphage -y

# Activate the conda environment
#source activate taxmyphage  # Use `source activate taxmyphage` if your conda version requires it

# If databases are not installed, install them
#taxmyphage install


# Run taxmyphage
taxmyphage run -i /scratch/jgianott/SAGE/SAGE_2024-2025/lbesanc1/mega_fasta.fasta -t 4


# Directory containing FASTA files
#input_directory="/scratch/jgianott/SAGE/SAGE_2024-2025/lbesanc1/mega_fasta.fasta"

# Loop through all .fasta files in the input directory
#for fasta_file in "$input_directory"/*.fasta; do
    # Check if the file exists to avoid errors
    #if [[ -f "$fasta_file" ]]; then
        #echo "Running taxmyphage on $fasta_file"
        #taxmyphage run -i "$fasta_file" -t 4
    #else
        #echo "No FASTA files found in the directory."
    #fi
#done

conda deactivate