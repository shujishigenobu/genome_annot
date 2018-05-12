VCF=ApL.hologenome.170808.pilonVariants.rmDUP.vcf
BAM=../bowtie_idx5_150410.on.ApL.hologenome.170808.bowtie2.sorted.bam
GENOME=../ApL.hologenome.170808.fasta

HAIRS=`basename $VCF .vcf`.hairs
extractHAIRS  --indels 1 --ref $GENOME --bam $BAM --VCF $VCF --out $HAIRS

OUT=`basename $VCF .vcf`.HAPCUT2.out
HAPCUT2 --fragments $HAIRS --vcf $VCF --output $OUT

