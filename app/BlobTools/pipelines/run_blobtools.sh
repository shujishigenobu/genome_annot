GENOME=ApL_SN190824_pseudohap2.1.NsRemoved.fasta
BAM="10xLinkedReads.on.ApL_SN190824_pseudohap2.1.sorted.bam"
HIT="ApL_SN190824_pseudohap2.1.fasta.vs.nt.megablast.out5.taxified.out"
HIT2="ApL_SN190824_pseudohap2.1.fasta.vsnr.dmnd.blastx.dmnd.taxified.out"
OUT=`basename ApL_SN190824_pseudohap2.1.NsRemoved.fasta .fasta`.blobtools

BLOBTOOLS=~/bio/apps/blobtools_v1.1.1/blobtools

## Create BlobDB
$BLOBTOOLS create \
-i $GENOME \
-b $BAM \
-t $HIT \
-t $HIT2 \
-o $OUT \

## Create View and Plot
BLOBDB=$OUT.blobDB.json

$BLOBTOOLS view  -i $BLOBDB -x bestsumorder

$BLOBTOOLS plot  -i $BLOBDB -x bestsumorder

