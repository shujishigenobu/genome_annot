
GENOME=../MAH_canu_quiv_170322.fasta
BAM=MAHx6.on.MAH_canu_quiv_170322.bowtie2.sorted.bam
NAME=%NAME%
TARGET="%TARGET%"
#MINDEPTH=0.2

MEM=16G

echo $NAME

java -Xmx$MEM -jar ~/bio/applications/pilon-1.21.jar \
  --genome $GENOME \
  --frags $BAM \
  --changes --vcf --tracks \
  --fix all,breaks \
  --targets $TARGET \
  --diploid \
  --output ${NAME} \
  --outdir pilon_out_MAH_${NAME}

# --mindepth $MINDEPTH \
