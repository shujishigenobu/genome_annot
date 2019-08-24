REFERENCE=../GCF_000184455.2_ASM18445v3_genomic.fna
DRAFT=../AspOr_RIB40_genome_NIBBv1.fasta
OUT=./MCM_out_RIB40_NIBBvsRefseq

MAUVE_JAR=/home/shige/bio/applications/mauve_snapshot_2015-02-13/Mauve.jar

# progressiveMauve should be executable 
#export PATH=$PATH:~/bio/applications/mauve_snapshot_2015-02-13/linux-x64

java -Xmx2G -cp $MAUVE_JAR org.gel.mauve.contigs.ContigOrderer \
  -output $OUT \
  -ref $REFERENCE \
  -draft $DRAFT \


