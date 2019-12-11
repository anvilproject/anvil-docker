# Install Bioconductor packages
BiocManager::install(c(
    "SingleCellExperiment", 
    "GenomicFeatures", 
    "GenomicAlignments", 
    "ShortRead", 
    "DESeq2", 
    "AnnotationHub", 
    "ExperimentHub", 
    "ensembldb", 
    "scRNAseq", 
    "scran", 
    "Rtsne"))
