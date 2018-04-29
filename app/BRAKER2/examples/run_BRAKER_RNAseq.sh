#$ -S /bin/bash

#=== example ===
# Gene prediction by BRAKER2 with RNAseq (only) data

cd $PBS_O_WORKDIR

GENOME=genome.fasta

BAM=merged.bam
#BAM: hisat2 mapping => sort by samtools => merge by samtools => merged.bam

NCPU=24

braker.pl --genome=$GENOME --bam=$BAM --cores $NCPU &> run_BRAKER.sh.log
