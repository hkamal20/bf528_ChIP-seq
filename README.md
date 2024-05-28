# bf528-individual-project-hkamal20
bf528-individual-project-hkamal20 created by GitHub Classroom


## ChIPseq


**Methods:**

Quality control was performed using FastQC v0.12.0 under default parameters. Next, adapter trimming was performed on the fastqc files with a single-ended adapter file using trimmomatic v0.39. Reads were aligned to the GENCODE mouse reference genome (GRCm39) using Bowtie2 v2.5.3 with default parameters. The alignments in the BAM files were sorted and indexed using Samtools v1.19 under sort and index utilities with default parameters. Alignment quality was checked using Samtools under the flagstat utility and Multiqc v1.21 with default parameters. The indexed BAM files were used to create a fingerprint plot using plotFingerprint from the deeptools package v3.5.6 under default parameters.

Aligned BAM files were converted to bigwig format using bamCoverage with default parameters from the deeptools package v3.5.6. Average scores for all bigwig files across all genomic regions were calculated using multiBigwigSummary in bins mode from the deeptools package. The compressed numpy array generated was used to produce a clustered heatmap of the Pearson correlation values between all samples using plotCorrelation from the deeptools package. Outliers were removed from the Pearson correlation calculation using the removeOutliers flag.

Peaks were called using findPeaks from Homer v4.11 specifying the "style factor" parameter and additional default parameters. Peaks files were converted to bed format using pos2bed.pl from Homer. Reproducible peaks were intersected using bedtools intersect from the bedtools package v2.31.0. Signal artifact regions were removed from the reproducible peak list that fell into blacklisted regions specified in the mm10-blacklist.v2.bed file. A filtered reproducible peak list was generated using bedtools intersect specifying using parameter -v. The filtered peaks were annotated to the mm10 mouse reference genome using annotatePeaks.pl from Homer using default parameters. Lastly, motif finding was performed to look for enriched motifs found in the filtered peaks file using findMotifsGenome.pl from Homer specifying 200 for the size of the region for motif finding.

Gene Set Enrichment Analysis was performed using the bioinformatics tool, DAVID, available on the NCI website. A list of genes from the list of reproducible peaks was passed to obtain information about functional annotations.

**Questions to Address:**

Quality of the sequencing reads and the alignment statistics
* Are there any concerning aspects of the quality control of your sequencing reads and alignment?
* Based on all of your quality control, will you exclude any samples from further analysis?

Generating a fingerprint plot and heatmap plot of correlation values between samples
* What are the plots showing?

Peak calling analysis 
* How many peaks are present in each of the replicates?
* How many peaks are present in your set of reproducible peaks? What strategy did you use to determine “reproducible” peaks?
* How many peaks remain after filtering out peaks overlapping blacklisted regions?

Motif Analysis and Gene Set Enrichment
* What are the main results of both of these analyses? 
* What do they imply about the function of the factor we are interested in?


**Deliverables:**
1. Produce a heatmap of correlation values between samples 
2. Generate a “fingerprint” plot using the deeptools plotFingerprint utility
3. Create a figure / table containing the number of peaks called in each replicate, and the number of reproducible peaks
4. A single BED file containing the reproducible peaks you determined from the experiment.
5. Perform motif finding on your reproducible peaks
   * Create a single table / figure with the most interesting results
7. Perform a gene enrichment analysis on the annotated peaks using a well-validated gene enrichment tool
   * Create a single table / figure with the most interesting results
9. Produce a figure that displays the proportions of where the factor of interest is binding (Promoter, Intergenic, Intron, Exon, TTS, etc.)
