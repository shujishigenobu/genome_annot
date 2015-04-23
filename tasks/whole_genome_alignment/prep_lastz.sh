#=== configuration ===
TARGET_FASTA=Rspe.fa.masked
QUERY_FASTA=Znev_genome_scaffold.fasta.softmasked

TARGET_DIR=Rspe
QUERY_DIR=Znev
#===

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

