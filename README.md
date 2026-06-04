# Taxon-classification-for-shotgun-metagenomes
This workflow is used for the taxonomy classification of shotgun metagenomes that was shared to Nicole
Author: Shaelyn Xu
Date:June 2026
Description:
This workflow performs host read decontamination followed by taxonomic classification and abundance 
re-estimation using Bowtie2, Kraken2, and Bracken.

Required software:
kneadata
Kraken2
Bracken

Required databases:
Human genome
kraken2 database
braken database

1. host decontamination 
bowtie2 -x <HOST_INDEX> \ # its path: /work/parkins_lab/conda_envs/human_genome_db
  -1 sample_R1.fastq.gz \
  -2 sample_R2.fastq.gz \
  --un-conc nonhuman_reads.fastq \
  -S human_reads.sam 

2. Kraken2 classification:
kraken2 --db <KRAKEN_DB_standard> \
  --paired \
  --report sample.kraken.report \
  --report-minimizer-data
  --minimum-hit-groups 3 \
  sample_clean_1.fastq.gz \
  sample_clean_2.fastq.gz > kraken_outputs/sample.kraken2

3. Bracken abundance estimation
bracken -d <KRAKEN_DB_standard> \
  -i sample.kraken.report \
  -r READ_LENGTH \ 
  -l S \ 
  -o sample.bracken \
  -w sample.breport
