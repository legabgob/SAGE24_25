# SAGE 2024 - Prophage analysis
Repository for SAGE course files related to prophage analysis project. Slides can be found at `prophages.pptx`. 

## Disclaimer -  reproducibility

GeNomad and BACPHLIP were installed in micromamba environments, which is the only way we could successfully install them. 

## Introduction

Bacteriophages, viruses targeting bacteria are prevalent in bacteria-rich environments, such as the bee gut microbiota. They play a crucial role in bacterial community regulation, horizontal gene transfer (HGT) either for Auxilliary Metabolic Genes (AMG), virulence factors or antibiotic resistance genes. Altogether, this makes bacteriophages quite interesting to study, especially given the lack of data available. It is also important to know that they mostly follow two different life cycles :

- Strictly lytic phages inject their genome into the bacteria, hijack the replication systems of the host bacteria to multiply, and then exit the bacteria via lysis, killing the bacteria.
- Lysogenic phages inject their genome in the bacteria, but can integrate the bacterial genome and stay in a dormant stage, when it is then referred to as a prophage. It can later exit the bacteria and enter a lytic cycle.

## Prophage detection - GeNomad

GeNomad was installed and ran using the `genomad_mamba_step1.sh` script. It gave as output a taxonomy estimation (`combined_provirus_taxonomy.tsv`), genomes of detected prophages and an annotation for genes detected in these prophage sequences. 

## Lifecycle classification - BACPHLIP

BACPHLIP was installed in a micromamba environment and ran using the `bacphlip.sh` script. As input, it needed all the prophage genome sequences in fasta format, which were obtained from the genomad output and regrouped in a single file (`mega_fasta.fasta`). It then returned as output a combined dataframe containing the probabilities of a phage either being lytic (virulent) or lysogenic (temperate). The result file can be found at `mega_fasta.fasta.bacphlip`. 

## Prevalence analysis

The output file coming from BACPHLIP was then combined with the metadata table in R, this to associate each prophage and its classification to the host sample and its metadata. Sadly, we lost the code used to make this combined dataframe, but itself can be found in `prevalence_final.csv`. 

## PyAni

We tried to use PyAni to get Average Nucleotide Identity (ANI) comparisons between whole genomes to try and get an idea of the genomic similarities between phages, but we failed to make it work. We tried the `anim` (using MUMMER) and `anib` (using BLAST+) methods. The former reported that we failed to compute at least one pairwise comparison and stopped running, and the latter was strangely no longer implemented in the version of PyAni we tried to use. The script used to try and run this analysis can be found at `run_pyani.sh`.
