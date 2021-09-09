#!/bin/sh

#SBATCH --partition=compute       ## use 'compute' by default, if you need >192 GB RAM, then use 'highmem'
#
#SBATCH --ntasks=1                ## You probably won't need to change this
#SBATCH --cpus-per-task=4         ## specifiy more CPUs here if codes support multi-threading
#SBATCH --mem-per-cpu=4000       ## set amount of RAM in MB, the compute partition has 192 GB maximum for all 40 cores, highmem has 380 GB

#SBATCH --time=04:00:00           ## Maximum runtime in HH:MM:SS, adjust as needed, try not to request too much 'overtime'

##The following command will be used to unload all the modules
module purge

##The following command will load SAMtools
module load SAMtools 

## First, change directory to your storage directory - edit this command so it is correct.
cd /path/to/storage/

## Make new directory for CRAM files
mkdir RAW_CRAM_files
cd RAW_CRAM_files

## Then download the file
wget ftp://ftp-trace.ncbi.nlm.nih.gov/1000genomes/ftp/1000G_2504_high_coverage/data/ERR3239276/NA06985.final.cram

## Go one directory back
cd ..

## Make new directory for GenomeAssemblyFiles and then cd  
mkdir Genome_assembly
cd Genome_assembly

## Downloading the GRCh38.p13_genomic.fna.gz file
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/GO_TO_CURRENT_VERSION/GCA_000001405.28_GRCh38.p13_genomic.fna.gz

## Uncompressing the file with bgzip
bgzip -d GCA_000001405.28_GRCh38.p13_genomic.fna.gz

## Generating the index using faidx
samtools faidx GCA_000001405.28_GRCh38.p13_genomic.fna.gz

## You need to change the '/path/to/storage/' paths to the correct paths for this to work.
samtools view --reference /path/to/storage/GCA_000001405.28_GRCh38.p13_genomic.fna -L /path/to/storage/selected_genes_FQ.bed -o NA06985_selected_genes.bam /path/to/storage/NA06985.final.cram

## Converting the BAM File to Fasta format
samtools fasta -o NA06985_selected_genes.fa -n NA06985_selected_genes.bam

#### Remaping the CRAM files to the genome (GRCh38)

## The following command will be used to unload all the modules
module purge

## Loading the module BWA
module load BWA

#### Creating index of the genome for BWA

## You need to change the '/path/to/storage/' paths to the correct paths for this to work.
bwa index /path/to/storage/GCA_000001405.28_GRCh38.p13_genomic.fna

## Loading the module SAMtools
module load SAMtools

## Mame new directories
mkdir /path/to/storage/fastq_files
mkdir /path/to/storage/bwa_mapping_output
cd /path/to/storage/fastq_files

### Split cram into fastq reads.

samtools fastq --reference /path/to/storage/GCA_000001405.28_GRCh38.p13_genomic.fna -1 NA06985.R1.fastq -2 NA06985.R2.fastq /path/to/storage/NA06985.final.cram

### Map fastq to genome.
## Changing the directory
cd /path/to/storage/bwa_mapping_output

## Perform the alignment using BWA
bwa aln -n 4 /path/to/storage/Genome_assembly/GCA_000001405.28_GRCh38.p13_genomic.fna /path/to/storage/fastq_files/NA06985.R1.fastq > NA06985_1.sai
bwa aln -n 4 /path/to/storage/Genome_assembly/GCA_000001405.28_GRCh38.p13_genomic.fna /path/to/storage/fastq_files/NA06985.R2.fastq > NA06985_2.sai

## Merging two files to one file
bwa sampe /path/to/storage/Genome_assembly/GCA_000001405.28_GRCh38.p13_genomic.fna NA06985_1.sai NA06985_2.sai /path/to/storage/fastq_files/NA06985.R1.fastq /path/to/storage/fastq_files/NA06985.R2.fastq > NA06985_bwa.sam
