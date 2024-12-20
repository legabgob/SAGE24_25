# Load necessary libraries
library(dplyr)
library(readr)
library(KEGGREST)
library(ggplot2)

# Load the data
file_path <- "/home/douhan/Desktop/predicted_genes/genes.bed"  # Replace with your file path
columns <- c("strain", "start", "end", "name", "score", "strand", "name2", "annotation", "WhatIsThis")
data <- read_tsv(file_path, col_names = columns)

# Remove unnecessary columns
data <- data %>% select(-name2, -WhatIsThis)

# Data Cleaning
data <- data %>%
    filter(!is.na(annotation)) %>%                # Remove rows without annotations
    mutate(annotation = tolower(trimws(annotation)))  # Standardize annotations

# Annotate Genes Using KEGG

# Function to fetch KEGG annotations
annotate_gene <- function(gene) {
    tryCatch({
        kegg_entry <- keggGet(gene)
        if (length(kegg_entry) > 0) {
            pathways <- paste(kegg_entry[[1]]$PATHWAY, collapse = "; ")
            enzymes <- paste(kegg_entry[[1]]$ENZYME, collapse = "; ")
            return(list(pathway = pathways, enzyme = enzymes))
        }
    }, error = function(e) {
        return(list(pathway = NA, enzyme = NA))
    })
}

# Apply KEGG annotation to the gene list
gene_list <- unique(data$annotation)
annotations <- lapply(gene_list, annotate_gene)
annotations_df <- data.frame(
    name = gene_list,
    pathway = sapply(annotations, function(x) x$pathway),
    enzyme = sapply(annotations, function(x) x$enzyme)
)

# Merge KEGG annotations with the original dataset
data <- left_join(data, annotations_df, by = "name")

# Functional Categorization
functional_groups <- list(
    transcription = c("transcription", "helix-turn-helix", "regulator", "repressor", "activator"),
    enzymes = c("metallo", "protease", "endonuclease", "integrase", "kinase", "transferase", "phosphatase"),
    structural = c("capsid", "tail", "coat", "fiber", "assembly"),
    dna_replication = c("helicase", "primase", "polymerase", "topoisomerase"),
    transporter = c("transporter", "channel", "porin", "pump"),
    metabolism = c("metabolism"),
    signal_transduction = c("signal transduction"),
    hypothetical = c("hypothetical", "unknown"),
    other = character()  # Catch-all for uncategorized annotations
)

# Function to categorize annotations
categorize_annotation <- function(annotation, pathway) {
    for (group in names(functional_groups)) {
        keywords <- functional_groups[[group]]
        if (any(grepl(paste(keywords, collapse = "|"), annotation)) ||
            any(grepl(paste(keywords, collapse = "|"), pathway))) {
            return(group)
        }
    }
    return("other")
}

# Apply categorization
data <- data %>%
    mutate(functional_group = mapply(categorize_annotation, annotation, pathway))

# Frequency Analysis
group_counts <- data %>%
    group_by(functional_group) %>%
    summarise(count = n()) %>%
    arrange(desc(count))

print(group_counts)

# Visualization

# Define a mapping of old bar labels to new labels
label_mapping <- c(
    "transcription" = "Transcription Regulators",
    "enzymes" = "Enzymes",
    "structural" = "Structural Proteins",
    "dna_replication" = "DNA Replication Proteins",
    "transporter" = "Transporters",
    "metabolism" = "Metabolic Pathways",
    "signal_transduction" = "Signal Transduction",
    "hypothetical" = "Hypothetical Proteins",
    "other" = "Other Functions"
)

# Apply the mapping to rename the functional groups
group_counts <- group_counts %>%
    mutate(
        functional_group = recode(functional_group, !!!label_mapping)
    )

# Plot with the updated names
ggplot(group_counts, aes(x = reorder(functional_group, -count), y = count)) +
    geom_bar(stat = "identity", fill = "skyblue1") +  # Changed bar color to skyblue1
    theme_minimal(base_family = "Arial") +  # Retain minimal theme with base font
    theme(
        plot.background = element_rect(fill = "#202020", color = NA),  # Dark background with no border
        panel.background = element_rect(fill = "#202020", color = NA),  # Panel background with no border
        panel.grid = element_blank(),  # Remove all grid lines
        axis.text = element_text(color = "white", size = 16),  # White axis text with increased font size
        axis.title = element_text(color = "white", size = 16),  # White axis titles with increased font size
        plot.title = element_text(color = "white", hjust = 0.5, size = 16, face = "bold"),  # Centered and styled title
        legend.text = element_text(size = 16),  # Increase legend text size if applicable
        legend.title = element_text(size = 16)  # Increase legend title size if applicable
    ) +
    labs(
        title = "",  # Centered title
        x = "Functional Group",  # Adjusted axis title
        y = "Count"
    )






# Save Results
output_path <- "/home/douhan/Desktop/kegg_annotated_genes.csv"
write.csv(data, output_path)
cat(paste("Annotated data saved to", output_path, "\n"))

# Save uncategorized annotations for further analysis
uncategorized <- data %>% filter(functional_group == "other") %>% pull(annotation)
write.csv(data.frame(uncategorized), "uncategorized_annotations.csv")
cat("Uncategorized annotations saved to 'uncategorized_annotations.csv' for review.\n")

