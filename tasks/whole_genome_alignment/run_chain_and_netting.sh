#=== configuration ===
TARGET_FASTA=Rspe.fa.masked
QUERY_FASTA=Mnat_assembly_v1.0.fa.masked.lt1k

AXTCHAIN_LINEAR_GAP=medium
AXTCHAIN_MIN_SCORE=5000

CHAINNET_MIN_SPACE=100
CHAINNET_MIN_SCORE=10000

#====

TARGET_DIR=Rspe
QUERY_DIR=Mnat

TARGET=$TARGET_DIR
QUERY=$QUERY_DIR

## prep

mkdir $TARGET_DIR $QUERY_DIR
faSplit byName $TARGET_FASTA $TARGET_DIR/
faSplit byName $QUERY_FASTA $QUERY_DIR/

for f in $TARGET_DIR/*.fa; do faToNib -softMask $f `echo $f |sed -e s/.fa/.nib/`; done
for f in $QUERY_DIR/*.fa;  do faToNib -softMask $f `echo $f |sed -e s/.fa/.nib/`; done

fast.rb ids $TARGET_FASTA >$TARGET.list
fast.rb ids $QUERY_FASTA >$QUERY.list

faSize $TARGET_FASTA -detailed > $TARGET.sizes
faSize $QUERY_FASTA -detailed > $QUERY.sizes

exit

## step 1

for f in *psl; do 
  axtChain $f $TARGET_DIR $QUERY_DIR stdout -linearGap=$AXTCHAIN_LINEAR_GAP -minScore=$AXTCHAIN_MIN_SCORE -psl | 
  chainAntiRepeat  $TARGET_DIR $QUERY_DIR stdin $f.chain ;
done


## step 2

chainMergeSort *chain > all.chain
chainPreNet all.chain $TARGET.sizes $QUERY.sizes all.pre.chain

## step 3

chainNet all.pre.chain -minSpace=$CHAINNET_MIN_SPACE minScore=$CHAINNET_MIN_SCORE $TARGET.sizes $QUERY.sizes target.net query.net

## step 4

netSyntenic target.net target.syn.net
netSyntenic query.net query.syn.net

